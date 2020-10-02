#!/usr/bin/env python

import os
import re
import subprocess
import logging

import sys

rootLogger = logging.getLogger()
rootLogger.setLevel(logging.INFO)
consoleHandler = logging.StreamHandler(sys.stdout)
consoleHandler.setFormatter(logging.Formatter("%(asctime)s - %(levelname)s - %(message)s"))
rootLogger.addHandler(consoleHandler)

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))


class TopologicalSort(object):
    def __init__(self, dependency_map):
        self._dependency_map = dependency_map
        self._already_processed = set()

    def _get_dependencies(self, item, root=None):

        if not root:
            root = item

        elif root == item:
            logging.warn("circular dependency detected in '{}'".format(item))
            raise StopIteration()

        dependencies = self._dependency_map.get(item, [])
        for dependency in dependencies:

            if dependency in self._already_processed:
                continue

            self._already_processed.add(dependency)

            for sub_dependency in self._get_dependencies(dependency, root=root):
                yield sub_dependency

            yield dependency

    def sort(self):
        # Reduction, connect all nodes to a dummy node and re-calculate
        special_package_id = 'topological-sort-special-node'
        self._dependency_map[special_package_id] = self._dependency_map.keys()
        sorted_dependencies = self._get_dependencies(special_package_id)
        sorted_dependencies = list(sorted_dependencies)
        del self._dependency_map[special_package_id]

        # Remove "noise" dependencies (only referenced, not declared)
        sorted_dependencies = filter(lambda x: x in self._dependency_map, sorted_dependencies)
        return sorted_dependencies


class DebianPackage(object):
    def __init__(self, file_path):
        metadata = subprocess.check_output('dpkg -I {}'.format(file_path), shell=True)
        metadata = metadata.replace('\n ', '\n')
        self._metadata = metadata
        self.id = self._get('Package')
        self.dependencies = list(self._get_dependencies())
        self.file_path = file_path

    def _get_dependencies(self):
        dependencies = self._get('Depends') + ',' + self._get('Pre-Depends')
        dependencies = re.split(r',|\|', dependencies)
        dependencies = map(lambda x: re.sub(r'\(.*\)|:any', '', x).strip(), dependencies)
        dependencies = filter(lambda x: x, dependencies)
        dependencies = set(dependencies)
        for dependency in dependencies:
            yield dependency

    def _get(self, key):
        search = re.search(r'\n{key}:(.*)\n[A-Z]'.format(key=key), self._metadata)
        return search.group(1).strip() if search else ''


def sort_debian_packages(directory_path):
    file_names = os.listdir(directory_path)
    debian_packages = {}
    dependency_map = {}
    for file_name in file_names:

        file_path = os.path.join(directory_path, file_name)

        if not os.path.isfile(file_path):
            continue

        debian_package = DebianPackage(file_path)
        debian_packages[debian_package.id] = debian_package
        dependency_map[debian_package.id] = debian_package.dependencies

    sorted_dependencies = TopologicalSort(dependency_map).sort()
    sorted_dependencies = map(lambda package_id: debian_packages[package_id].file_path, sorted_dependencies)
    return sorted_dependencies


def main():
    # ------------------
    # Sort the packages using topological sort

    packages_dir_path = os.path.join(SCRIPT_DIR, 'packages')
    logging.info('sorting packages in "{}" using topological sort ...'.format(packages_dir_path))
    sorted_packages = sort_debian_packages(packages_dir_path)

    # ------------------
    # Install the packages in the sorted order

    for index, package_file_path in enumerate(sorted_packages):
        command = 'dpkg -i {}'.format(package_file_path)
        logging.info('executing "{}" ...'.format(command))
        subprocess.check_call(command, shell=True)


if __name__ == '__main__':

    if os.geteuid() != 0:
        logging.error('must be run as root')
        sys.exit(1)

    try:
        main()
    except:
        logging.error('failed to install packages', exc_info=True)
        sys.exit(1)
