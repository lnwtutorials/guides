https://www.tldp.org/LDP/abs/html/index.html
https://www.tldp.org/LDP/abs/html/string-manipulation.html
https://www.tldp.org/LDP/abs/html/sha-bang.html

The shell is a command interpreter. More than just the insulating layer between the operating system kernel and the user, it's also a fairly powerful programming language
A shell script is a quick-and-dirty method of prototyping a complex application.	

When not to use shell scripts
    • Resource-intensive tasks, especially where speed is a factor (sorting, hashing, recursion [2] ...)
    • Procedures involving heavy-duty math operations, especially floating point arithmetic, arbitrary precision calculations, or complex numbers (use C++ or FORTRAN instead)
    • Cross-platform portability required (use C or Java instead)
    • Complex applications, where structured programming is a necessity (type-checking of variables, function prototypes, etc.)
    • Mission-critical applications upon which you are betting the future of the company
    • Situations where security is important, where you need to guarantee the integrity of your system and protect against intrusion, cracking, and vandalism
    • Project consists of sub-components with interlocking dependencies
    • Extensive file operations required (Bash is limited to serial file access, and that only in a particularly clumsy and inefficient line-by-line fashion.)
    • Need native support for muti-dimensional arrays
    • Need data structures, such as linked lists or trees
    • Need to generate / manipulate graphics or GUIs
    • Need direct access to system hardware or external peripherals
    • Need port or socket I/O
    • Need to use libraries or interface with legacy code
    • Proprietary, closed-source applications (Shell scripts put the source code right out in the open for all the world to see.)

If any of the above applies, consider a more powerful scripting language -- perhaps Perl, Tcl, Python, Ruby -- or possibly a compiled language such as C, C++, or Java. Even then, prototyping the application as a shell script might still be a useful development step.
ROOT_UID=0     # Only users with $UID 0 have root privileges.
LINES=50       # Default number of lines saved.
E_XCD=86       # Can't change directory?
E_NOTROOT=87   # Non-root exit error.


Script-1:
# Run as root, of course.
if [ "$UID" -ne "$ROOT_UID" ]	# ROOT_UID=0  ##Only users with $UID 0 have root privileges.
then
  echo "Must be root to run this script."
  exit $E_NOTROOT
fi 

Script 2:
# checking command-line arguments
if [ -n "$1" ] 		# Test whether command-line argument is present (non-empty).
then
  lines=$1
else  
  lines=$LINES 		# LINES=50, Default, if not specified on command-line.
fi
==== or === [ a bit advanced for this stage ]
#    E_WRONGARGS=85  # Non-numerical argument (bad argument format).
#    case "$1" in
#    ""      ) lines=50;;
#    *[!0-9]*) echo "Usage: `basename $0` lines-to-cleanup";
#     exit $E_WRONGARGS;;
#    *       ) lines=$1;;
#    esac

Script 3:
### DoubleCheck if you in correct Directory.
if [ ${PWD} != ${LOG_DIR} ];then
        echo "Not Changed to $LOG_DIR."
        exit $E_XCD
else
        echo "Directory Check passed ..."
        echo "You now in $PWD"
fi
==================================================
cd $LOG_DIR || { echo "Not Able to change Directory at $LOG_DIR" ; exit $E_XCD; }
==================================================
Script 4:
##Checking if Directory
filename=/home/stpl/1
echo "start \c";

if [ -f "$filename" ]; then
	echo "$filename is a File";
elif [ -d "$filename" ]; then
	echo " $filename is a Directory";
fi

Special Character : https://www.tldp.org/LDP/abs/html/special-chars.html 
==================================================
#	Comments. Lines beginning with a # (with the exception of #!) are comments and will not be executed.
; 	Command separator [semicolon]. Permits putting two or more commands on the same line.
;;	Terminator in a case option [double semicolon].
;;&, ;&	Terminators in a case option (version 4+ of Bash). 
.	"dot" command [period]. Equivalent to source (see Example 15-22). This is a bash builtin
"	partial quoting [double quote]. "STRING" preserves (from interpretation) most of the special characters within STRING
'	full quoting [single quote]. 'STRING' preserves all special characters within STRING. It a stronger form of quoting than "STRING"
,	comma operator. The comma operator [1] links together a series of arithmetic operations. All are evaluated, but only the last one is returned.


[root@host1 ~]# cat f.sh 
#!/bin/bash
#PATH=$PATH:/bin:/sbin:/usr/bin/:/usr/sbin

LOG_DIR=/var/log
FILENAME=$LOG_DIR/dmesg
USER_UID=1000
LINES=50
E_XCD=84
E_NOTROOT=85

cd $LOG_DIR
echo $PWD

if [ -d "$LOG_DIR" ]; then
	echo "$LOG_DIR is a directory"
fi
echo hello
if [ -x "$FILENAME" ]; then
	echo "$FILENAME is a file"
else
	echo "file not exist"
fi

# <<comment
### DoubleCheck if you in correct Directory.
if [ ${PWD} != ${LOG_DIR} ];then
	echo "Not Changed to $LOG_DIR."
	exit $E_XCD
else
	echo "Directory Check passed ..."
	echo "You now in $PWD"
fi

#cd $LOG_DIR || { echo "Can't change to $LOG_DIR" ; exit $E_XCD; }


tail -n $LINES messages > /tmp/t1
mv /tmp/t1 messages2
echo "Starting To clean Log files"
#comment

================================================
# ./v1.sh 
2 --- whatever
# tail -3 v1.sh 
mix_beg=2\ ---\ whatever
echo "$mix_beg"
================================================

[root@host1 variable]# cat v2.sh 
#!/bin/bash
myvar=
myvar=1
unset myvar
if [ -z "$myvar" ];then
echo "\$myvar is NULL."
fi
let "myvar += 0"
echo $myvar

[root@host1 variable]# ./v2.sh 
$myvar is NULL.
0


================================================

for i in 7 8 9;do echo -n "$i ";done;echo
read -p "input Name " name
read -sp "input pass " pass
echo
echo $name $pass
exit 0
=={v5}=============================================
#!/bin/bash
MINPARAM=3
ARGS=$#

for i in $*;do echo "Parameter \"$i\" is supplied.";done
echo "Total \"$#\" argument have supplied."

<<comment
if [ -n $1 ];then
echo "Parameter \"${1}\" is supplied."
fi
if [ -n $2 ];then
echo "Parameter \"${2}\" is supplied."
fi
if [ -n $3 ];then
echo "Parameter \"${3}\" is supplied."
fi
echo
echo "All the commandline parameters are : "$*""
echo "All the commandline parameters are : "$#""

if [ $# -lt $MINPARAM ]; then
	echo "At least $MINPARAM is required."
	echo
fi
comment
exit 0

[root@host1 variable]# ./v5.sh 10 20 30
Parameter "10" is supplied.
Parameter "20" is supplied.
Parameter "30" is supplied.
Total "3" argument have supplied.

NOTE :
--------------------------------------------------------------------------------------------
COUNT=0
for i in ${*}; do COUNT=$((COUNT+1));echo "At $COUNT argument is - ${i} " ; done
echo
echo "All parameter is : \"${*}\" "
echo "\"${#}\" parameter have supplied "
--------------------------------------------------------------------------------------------

================================================
[root@host1 variable]# cat v6.sh 
#!/bin/bash
if [ -z $1 ];then
	echo "Usage: `basename $0` <some num args>"
fi
shift 3
echo $1
exit 0

[root@host1 variable]# ./v6.sh 2 3 4 5 6
5
================================================
command &>filename redirects both the stdout and the stderr of command to filename.
command >&2 redirects stdout of command to stderr.
echo $(ls)
grep '[Ff]i*' *.sh

https://www.tldp.org/LDP/abs/html/escapingsection.html 





Example 5-3. Detecting key-presses
================================================

================================================

*********************************************************************************
-a 	AND 	(&&)
-o 	OR 	(||)
-gt
-lt
-eq
-ne
-f	file
-d	directory
-n	argument
-z
!=
-nt Newer then
-ot older then
-ef hardlink of same file

File test operators
===========
-e file exist
-f regular file
-s Not zero size file
-d file directory
-b file is a block device
-c character device
-p pipe
-h sysmbolic link
-L Symbolic Link
-S socket
-r read permission
-w write permission
-x execute permission
-g set-group-id
-u set-user-id
-k sticky-bit set
-O owner of file
-G groupID
-N file modified since it was last read
!  "Not" or reverse
f1 -nt f2	f1 newer then f2
f1 -ot f2	f1 Older then f2
f1 -et f2	f1 and f2 are hard link of same file.
--------------------------------------------------------------------------------------------------------------------
$BASH
$BASH_ENV
$BASHPID $$
$BASH_SUBSHELL
--------------------------------------------------------------------------------------------------------------------
#!/bin/bash
echo "\$\$ - $$"
echo "$BASH_SUBSHELL"
echo "$BASHPID"
echo
( echo "\$\$ - $$"
echo "$BASH_SUBSHELL"
echo "$BASHPID" )
--------------------------------------------------------------------------------------------------------------------

$BASH
$BASH_ENV
$BASHPID $$
$BASH_SUBSHELL
$BASH_VERSINFO
$CDPATH
$DIRSTACK
$EUID
$EDITOR
$FUNCNAME
$GLOBIGNORE
$HOME
$HOSTNAME
$HOSTTYPE 
${PIPESTATUS[@]}
$PPID
$PWD
$REPLY
$SECONDS

--------------------------------------------------------------------------------------------------------------------

bash -c 'set a b c; IFS=":"; echo "$*" '

# echo $PIPESTATUS
0
# ls -l | bogus
bash: bogus: command not found...
# echo $?
127
# ls -l | bogus
bash: bogus: command not found...
# echo ${PIPESTATUS[1]}
127
