# ZAP Scanning Report

ZAP by [Checkmarx](https://checkmarx.com/).


## Summary of Alerts

| Risk Level | Number of Alerts |
| --- | --- |
| High | 4 |
| Medium | 10 |
| Low | 8 |
| Informational | 15 |




## Insights

| Level | Reason | Site | Description | Statistic |
| --- | --- | --- | --- | --- |
| Low | Warning |  | ZAP errors logged - see the zap.log file for details | 18    |
| Low | Warning |  | ZAP warnings logged - see the zap.log file for details | 8    |
| Low | Exceeded Low |  | Percentage of network failures | 5 % |
| Info | Informational | http://badstore | Percentage of responses with status code 2xx | 61 % |
| Info | Informational | http://badstore | Percentage of responses with status code 3xx | 2 % |
| Info | Exceeded Low | http://badstore | Percentage of responses with status code 4xx | 17 % |
| Info | Exceeded Low | http://badstore | Percentage of responses with status code 5xx | 18 % |
| Info | Informational | http://badstore | Percentage of endpoints with content type application/msword | 2 % |
| Info | Informational | http://badstore | Percentage of endpoints with content type application/pdf | 2 % |
| Info | Informational | http://badstore | Percentage of endpoints with content type image/jpeg | 21 % |
| Info | Informational | http://badstore | Percentage of endpoints with content type text/css | 2 % |
| Info | Informational | http://badstore | Percentage of endpoints with content type text/html | 67 % |
| Info | Informational | http://badstore | Percentage of endpoints with content type text/javascript | 2 % |
| Info | Informational | http://badstore | Percentage of endpoints with content type text/plain | 2 % |
| Info | Informational | http://badstore | Percentage of endpoints with method GET | 86 % |
| Info | Informational | http://badstore | Percentage of endpoints with method POST | 13 % |
| Info | Informational | http://badstore | Count of total endpoints | 46    |
| Info | Informational | http://badstore | Percentage of slow responses | 4 % |
| Info | Informational | https://model-hub.mozilla.org | Percentage of responses with status code 2xx | 100 % |
| Info | Informational | https://model-hub.mozilla.org | Percentage of slow responses | 100 % |




## Alerts

| Name | Risk Level | Number of Instances |
| --- | --- | --- |
| Cross Site Scripting (Reflected) | High | 1 |
| SQL Injection | High | 4 |
| SQL Injection - MySQL | High | 4 |
| SQL Injection - MySQL (Time Based) | High | 1 |
| Absence of Anti-CSRF Tokens | Medium | Systemic |
| Anti-CSRF Tokens Check | Medium | 2 |
| Backup File Disclosure | Medium | 1 |
| Buffer Overflow | Medium | 10 |
| Bypassing 403 | Medium | 7 |
| Content Security Policy (CSP) Header Not Set | Medium | Systemic |
| Integer Overflow Error | Medium | 10 |
| Missing Anti-clickjacking Header | Medium | Systemic |
| Relative Path Confusion | Medium | 9 |
| Source Code Disclosure - SQL | Medium | 1 |
| Cookie No HttpOnly Flag | Low | 3 |
| Cookie without SameSite Attribute | Low | 3 |
| In Page Banner Information Leak | Low | Systemic |
| Insufficient Site Isolation Against Spectre Vulnerability | Low | Systemic |
| Permissions Policy Header Not Set | Low | Systemic |
| Private IP Disclosure | Low | 1 |
| Server Leaks Version Information via "Server" HTTP Response Header Field | Low | Systemic |
| X-Content-Type-Options Header Missing | Low | Systemic |
| Authentication Request Identified | Informational | 3 |
| Base64 Disclosure | Informational | 6 |
| Cookie Slack Detector | Informational | Systemic |
| GET for POST | Informational | 4 |
| Information Disclosure - Suspicious Comments | Informational | 1 |
| Modern Web Application | Informational | 1 |
| Non-Storable Content | Informational | 2 |
| Sec-Fetch-Dest Header is Missing | Informational | 4 |
| Sec-Fetch-Mode Header is Missing | Informational | 4 |
| Sec-Fetch-Site Header is Missing | Informational | 4 |
| Sec-Fetch-User Header is Missing | Informational | 4 |
| Session Management Response Identified | Informational | 4 |
| Storable and Cacheable Content | Informational | Systemic |
| User Agent Fuzzer | Informational | Systemic |
| User Controllable HTML Element Attribute (Potential XSS) | Informational | 1 |




## Alert Detail



### [ Cross Site Scripting (Reflected) ](https://www.zaproxy.org/docs/alerts/40012/)



##### High (Medium)

### Description

Cross-site Scripting (XSS) is an attack technique that involves echoing attacker-supplied code into a user's browser instance. A browser instance can be a standard web browser client, or a browser object embedded in a software product such as the browser within WinAmp, an RSS reader, or an email client. The code itself is usually written in HTML/JavaScript, but may also extend to VBScript, ActiveX, Java, Flash, or any other browser-supported technology.
When an attacker gets a user's browser to execute his/her code, the code will run within the security context (or zone) of the hosting web site. With this level of privilege, the code has the ability to read, modify and transmit any sensitive data accessible by the browser. A Cross-site Scripted user could have his/her account hijacked (cookie theft), their browser redirected to another location, or possibly shown fraudulent content delivered by the web site they are visiting. Cross-site Scripting attacks essentially compromise the trust relationship between a user and the web site. Applications utilizing browser object instances which load content from the file system may execute code under the local machine zone allowing for system compromise.

There are three types of Cross-site Scripting attacks: non-persistent, persistent and DOM-based.
Non-persistent attacks and DOM-based attacks require a user to either visit a specially crafted link laced with malicious code, or visit a malicious web page containing a web form, which when posted to the vulnerable site, will mount the attack. Using a malicious form will oftentimes take place when the vulnerable resource only accepts HTTP POST requests. In such a case, the form can be submitted automatically, without the victim's knowledge (e.g. by using JavaScript). Upon clicking on the malicious link or submitting the malicious form, the XSS payload will get echoed back and will get interpreted by the user's browser and execute. Another technique to send almost arbitrary requests (GET and POST) is by using an embedded client, such as Adobe Flash.
Persistent attacks occur when the malicious code is submitted to a web site where it's stored for a period of time. Examples of an attacker's favorite targets often include message board posts, web mail messages, and web chat software. The unsuspecting user is not required to interact with any additional site/link (e.g. an attacker site or a malicious link sent via email), just simply view the web page containing the code.

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=moduser
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(DoMods,email,pwdhint)`
  * Method: `POST`
  * Parameter: `email`
  * Attack: `</h2><scrIpt>alert(1);</scRipt><h2>`
  * Evidence: `</h2><scrIpt>alert(1);</scRipt><h2>`
  * Other Info: ``


Instances: 1

### Solution

Phase: Architecture and Design
Use a vetted library or framework that does not allow this weakness to occur or provides constructs that make this weakness easier to avoid.
Examples of libraries and frameworks that make it easier to generate properly encoded output include Microsoft's Anti-XSS library, the OWASP ESAPI Encoding module, and Apache Wicket.

Phases: Implementation; Architecture and Design
Understand the context in which your data will be used and the encoding that will be expected. This is especially important when transmitting data between different components, or when generating outputs that can contain multiple encodings at the same time, such as web pages or multi-part mail messages. Study all expected communication protocols and data representations to determine the required encoding strategies.
For any data that will be output to another web page, especially any data that was received from external inputs, use the appropriate encoding on all non-alphanumeric characters.
Consult the XSS Prevention Cheat Sheet for more details on the types of encoding and escaping that are needed.

Phase: Architecture and Design
For any security checks that are performed on the client side, ensure that these checks are duplicated on the server side, in order to avoid CWE-602. Attackers can bypass the client-side checks by modifying values after the checks have been performed, or by changing the client to remove the client-side checks entirely. Then, these modified values would be submitted to the server.

If available, use structured mechanisms that automatically enforce the separation between data and code. These mechanisms may be able to provide the relevant quoting, encoding, and validation automatically, instead of relying on the developer to provide this capability at every point where output is generated.

Phase: Implementation
For every web page that is generated, use and specify a character encoding such as ISO-8859-1 or UTF-8. When an encoding is not specified, the web browser may choose a different encoding by guessing which encoding is actually being used by the web page. This can cause the web browser to treat certain sequences as special, opening up the client to subtle XSS attacks. See CWE-116 for more mitigations related to encoding/escaping.

To help mitigate XSS attacks against the user's session cookie, set the session cookie to be HttpOnly. In browsers that support the HttpOnly feature (such as more recent versions of Internet Explorer and Firefox), this attribute can prevent the user's session cookie from being accessible to malicious client-side scripts that use document.cookie. This is not a complete solution, since HttpOnly is not supported by all browsers. More importantly, XMLHTTPRequest and other powerful browser technologies provide read access to HTTP headers, including the Set-Cookie header in which the HttpOnly flag is set.

Assume all input is malicious. Use an "accept known good" input validation strategy, i.e., use an allow list of acceptable inputs that strictly conform to specifications. Reject any input that does not strictly conform to specifications, or transform it into something that does. Do not rely exclusively on looking for malicious or malformed inputs (i.e., do not rely on a deny list). However, deny lists can be useful for detecting potential attacks or determining which inputs are so malformed that they should be rejected outright.

When performing input validation, consider all potentially relevant properties, including length, type of input, the full range of acceptable values, missing or extra inputs, syntax, consistency across related fields, and conformance to business rules. As an example of business rule logic, "boat" may be syntactically valid because it only contains alphanumeric characters, but it is not valid if you are expecting colors such as "red" or "blue."

Ensure that you perform input validation at well-defined interfaces within the application. This will help protect the application even if a component is reused or moved elsewhere.
	

### Reference


* [ https://owasp.org/www-community/attacks/xss/ ](https://owasp.org/www-community/attacks/xss/)
* [ https://cwe.mitre.org/data/definitions/79.html ](https://cwe.mitre.org/data/definitions/79.html)


#### CWE Id: [ 79 ](https://cwe.mitre.org/data/definitions/79.html)


#### WASC Id: 8

#### Source ID: 1

### [ SQL Injection ](https://www.zaproxy.org/docs/alerts/40018/)



##### High (Low)

### Description

SQL injection may be possible.

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=search&searchquery=%2527
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action,searchquery)`
  * Method: `GET`
  * Parameter: `searchquery`
  * Attack: `'`
  * Evidence: `HTTP/1.1 500 Internal Server Error`
  * Other Info: ``
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `email`
  * Attack: `'`
  * Evidence: `HTTP/1.1 500 Internal Server Error`
  * Other Info: ``
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `fullname`
  * Attack: `'`
  * Evidence: `HTTP/1.1 500 Internal Server Error`
  * Other Info: ``
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=login
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,passwd)`
  * Method: `POST`
  * Parameter: `email`
  * Attack: `'`
  * Evidence: `HTTP/1.1 500 Internal Server Error`
  * Other Info: ``


Instances: 4

### Solution

Do not trust client side input, even if there is client side validation in place.
In general, type check all data on the server side.
If the application uses JDBC, use PreparedStatement or CallableStatement, with parameters passed by '?'
If the application uses ASP, use ADO Command Objects with strong type checking and parameterized queries.
If database Stored Procedures can be used, use them.
Do *not* concatenate strings into queries in the stored procedure, or use 'exec', 'exec immediate', or equivalent functionality!
Do not create dynamic SQL queries using simple string concatenation.
Escape all data received from the client.
Apply an 'allow list' of allowed characters, or a 'deny list' of disallowed characters in user input.
Apply the principle of least privilege by using the least privileged database user possible.
In particular, avoid using the 'sa' or 'db-owner' database users. This does not eliminate SQL injection, but minimizes its impact.
Grant the minimum database access that is necessary for the application.

### Reference


* [ https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)


#### CWE Id: [ 89 ](https://cwe.mitre.org/data/definitions/89.html)


#### WASC Id: 19

#### Source ID: 1

### [ SQL Injection - MySQL ](https://www.zaproxy.org/docs/alerts/40018/)



##### High (Medium)

### Description

SQL injection may be possible.

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=cartadd
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(Add Items to Cart,cartitem)`
  * Method: `POST`
  * Parameter: `cartitem`
  * Attack: `'`
  * Evidence: `You have an error in your SQL syntax`
  * Other Info: `RDBMS [MySQL] likely, given error message regular expression [\QYou have an error in your SQL syntax\E] matched by the HTML results.
The vulnerability was detected by manipulating the parameter to cause a database error message to be returned and recognised.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=moduser
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(DoMods,email,pwdhint)`
  * Method: `POST`
  * Parameter: `email`
  * Attack: `'`
  * Evidence: `You have an error in your SQL syntax`
  * Other Info: `RDBMS [MySQL] likely, given error message regular expression [\QYou have an error in your SQL syntax\E] matched by the HTML results.
The vulnerability was detected by manipulating the parameter to cause a database error message to be returned and recognised.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `pwdhint`
  * Attack: `'`
  * Evidence: `You have an error in your SQL syntax`
  * Other Info: `RDBMS [MySQL] likely, given error message regular expression [\QYou have an error in your SQL syntax\E] matched by the HTML results.
The vulnerability was detected by manipulating the parameter to cause a database error message to be returned and recognised.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `role`
  * Attack: `'`
  * Evidence: `You have an error in your SQL syntax`
  * Other Info: `RDBMS [MySQL] likely, given error message regular expression [\QYou have an error in your SQL syntax\E] matched by the HTML results.
The vulnerability was detected by manipulating the parameter to cause a database error message to be returned and recognised.`


Instances: 4

### Solution

Do not trust client side input, even if there is client side validation in place.
In general, type check all data on the server side.
If the application uses JDBC, use PreparedStatement or CallableStatement, with parameters passed by '?'
If the application uses ASP, use ADO Command Objects with strong type checking and parameterized queries.
If database Stored Procedures can be used, use them.
Do *not* concatenate strings into queries in the stored procedure, or use 'exec', 'exec immediate', or equivalent functionality!
Do not create dynamic SQL queries using simple string concatenation.
Escape all data received from the client.
Apply an 'allow list' of allowed characters, or a 'deny list' of disallowed characters in user input.
Apply the principle of least privilege by using the least privileged database user possible.
In particular, avoid using the 'sa' or 'db-owner' database users. This does not eliminate SQL injection, but minimizes its impact.
Grant the minimum database access that is necessary for the application.

### Reference


* [ https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)


#### CWE Id: [ 89 ](https://cwe.mitre.org/data/definitions/89.html)


#### WASC Id: 19

#### Source ID: 1

### [ SQL Injection - MySQL (Time Based) ](https://www.zaproxy.org/docs/alerts/40019/)



##### High (Medium)

### Description

SQL injection may be possible.

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=cartadd
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(Add Items to Cart,cartitem)`
  * Method: `POST`
  * Parameter: `cartitem`
  * Attack: `1000' and 0 in (select sleep(15) ) -- `
  * Evidence: ``
  * Other Info: `The query time is controllable using parameter value [1000' and 0 in (select sleep(15) ) -- ], which caused the request to take [15,028] milliseconds, when the original unmodified query with value [1000] took [0] milliseconds.`


Instances: 1

### Solution

Do not trust client side input, even if there is client side validation in place.
In general, type check all data on the server side.
If the application uses JDBC, use PreparedStatement or CallableStatement, with parameters passed by '?'
If the application uses ASP, use ADO Command Objects with strong type checking and parameterized queries.
If database Stored Procedures can be used, use them.
Do *not* concatenate strings into queries in the stored procedure, or use 'exec', 'exec immediate', or equivalent functionality!
Do not create dynamic SQL queries using simple string concatenation.
Escape all data received from the client.
Apply an 'allow list' of allowed characters, or a 'deny list' of disallowed characters in user input.
Apply the principle of least privilege by using the least privileged database user possible.
In particular, avoid using the 'sa' or 'db-owner' database users. This does not eliminate SQL injection, but minimizes its impact.
Grant the minimum database access that is necessary for the application.

### Reference


* [ https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)


#### CWE Id: [ 89 ](https://cwe.mitre.org/data/definitions/89.html)


#### WASC Id: 19

#### Source ID: 1

### [ Absence of Anti-CSRF Tokens ](https://www.zaproxy.org/docs/alerts/10202/)



##### Medium (Low)

### Description

No Anti-CSRF tokens were found in a HTML submission form.
A cross-site request forgery is an attack that involves forcing a victim to send an HTTP request to a target destination without their knowledge or intent in order to perform an action as the victim. The underlying cause is application functionality using predictable URL/form actions in a repeatable way. The nature of the attack is that CSRF exploits the trust that a web site has for a user. By contrast, cross-site scripting (XSS) exploits the trust that a user has for a web site. Like XSS, CSRF attacks are not necessarily cross-site, but they can be. Cross-site request forgery is also known as CSRF, XSRF, one-click attack, session riding, confused deputy, and sea surf.

CSRF attacks are effective in a number of situations, including:
    * The victim has an active session on the target site.
    * The victim is authenticated via HTTP auth on the target site.
    * The victim is on the same local network as the target site.

CSRF has primarily been used to perform an action against a target site using the victim's privileges, but recent techniques have been discovered to disclose information by gaining access to the response. The risk of information disclosure is dramatically increased when the target site is vulnerable to XSS, because XSS can be used as a platform for CSRF, allowing the attack to operate within the bounds of the same-origin policy.

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=guestbook
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<form method="post" action="/cgi-bin/badstore.cgi?action=doguestbook" enctype="multipart/form-data">`
  * Other Info: `No known Anti-CSRF token [anticsrf, CSRFToken, __RequestVerificationToken, csrfmiddlewaretoken, authenticity_token, OWASP_CSRFTOKEN, anoncsrf, csrf_token, _csrf, _csrfSecret, __csrf_magic, CSRF, _token, _csrf_token, _csrfToken] was found in the following HTML form: [Form 2: "email" "name" ].`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=loginregister
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<form method="post" action="/cgi-bin/badstore.cgi?action=login">`
  * Other Info: `No known Anti-CSRF token [anticsrf, CSRFToken, __RequestVerificationToken, csrfmiddlewaretoken, authenticity_token, OWASP_CSRFTOKEN, anoncsrf, csrf_token, _csrf, _csrfSecret, __csrf_magic, CSRF, _token, _csrf_token, _csrfToken] was found in the following HTML form: [Form 2: "email" "passwd" ].`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=myaccount
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<form method="post" action="/cgi-bin/badstore.cgi?action=moduser" enctype="multipart/form-data">`
  * Other Info: `No known Anti-CSRF token [anticsrf, CSRFToken, __RequestVerificationToken, csrfmiddlewaretoken, authenticity_token, OWASP_CSRFTOKEN, anoncsrf, csrf_token, _csrf, _csrfSecret, __csrf_magic, CSRF, _token, _csrf_token, _csrfToken] was found in the following HTML form: [Form 2: "DoMods" "email" ].`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=loginregister
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<form method="post" action="/cgi-bin/badstore.cgi?action=register">`
  * Other Info: `No known Anti-CSRF token [anticsrf, CSRFToken, __RequestVerificationToken, csrfmiddlewaretoken, authenticity_token, OWASP_CSRFTOKEN, anoncsrf, csrf_token, _csrf, _csrfSecret, __csrf_magic, CSRF, _token, _csrf_token, _csrfToken] was found in the following HTML form: [Form 3: "email" "fullname" "passwd" "role" ].`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=supplierlogin
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<form method="post" action="/cgi-bin/badstore.cgi?action=supplierportal">`
  * Other Info: `No known Anti-CSRF token [anticsrf, CSRFToken, __RequestVerificationToken, csrfmiddlewaretoken, authenticity_token, OWASP_CSRFTOKEN, anoncsrf, csrf_token, _csrf, _csrfSecret, __csrf_magic, CSRF, _token, _csrf_token, _csrfToken] was found in the following HTML form: [Form 2: "email" "passwd" ].`

Instances: Systemic


### Solution

Phase: Architecture and Design
Use a vetted library or framework that does not allow this weakness to occur or provides constructs that make this weakness easier to avoid.
For example, use anti-CSRF packages such as the OWASP CSRFGuard.

Phase: Implementation
Ensure that your application is free of cross-site scripting issues, because most CSRF defenses can be bypassed using attacker-controlled script.

Phase: Architecture and Design
Generate a unique nonce for each form, place the nonce into the form, and verify the nonce upon receipt of the form. Be sure that the nonce is not predictable (CWE-330).
Note that this can be bypassed using XSS.

Identify especially dangerous operations. When the user performs a dangerous operation, send a separate confirmation request to ensure that the user intended to perform that operation.
Note that this can be bypassed using XSS.

Use the ESAPI Session Management control.
This control includes a component for CSRF.

Do not use the GET method for any request that triggers a state change.

Phase: Implementation
Check the HTTP Referer header to see if the request originated from an expected page. This could break legitimate functionality, because users or proxies may have disabled sending the Referer for privacy reasons.

### Reference


* [ https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html)
* [ https://cwe.mitre.org/data/definitions/352.html ](https://cwe.mitre.org/data/definitions/352.html)


#### CWE Id: [ 352 ](https://cwe.mitre.org/data/definitions/352.html)


#### WASC Id: 9

#### Source ID: 3

### [ Anti-CSRF Tokens Check ](https://www.zaproxy.org/docs/alerts/20012/)



##### Medium (Medium)

### Description

A cross-site request forgery is an attack that involves forcing a victim to send an HTTP request to a target destination without their knowledge or intent in order to perform an action as the victim. The underlying cause is application functionality using predictable URL/form actions in a repeatable way. The nature of the attack is that CSRF exploits the trust that a web site has for a user. By contrast, cross-site scripting (XSS) exploits the trust that a user has for a web site. Like XSS, CSRF attacks are not necessarily cross-site, but they can be. Cross-site request forgery is also known as CSRF, XSRF, one-click attack, session riding, confused deputy, and sea surf.

CSRF attacks are effective in a number of situations, including:
    * The victim has an active session on the target site.
    * The victim is authenticated via HTTP auth on the target site.
    * The victim is on the same local network as the target site.

CSRF has primarily been used to perform an action against a target site using the victim's privileges, but recent techniques have been discovered to disclose information by gaining access to the response. The risk of information disclosure is dramatically increased when the target site is vulnerable to XSS, because XSS can be used as a platform for CSRF, allowing the attack to operate within the bounds of the same-origin policy.

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=supupload
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(Upload,newfilename,uploaded_file)`
  * Method: `POST`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<form method="get" action="badstore.cgi">`
  * Other Info: ``
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=doguestbook
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(comments,email,name)`
  * Method: `POST`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<form method="get" action="badstore.cgi">`
  * Other Info: ``


Instances: 2

### Solution

Phase: Architecture and Design
Use a vetted library or framework that does not allow this weakness to occur or provides constructs that make this weakness easier to avoid.
For example, use anti-CSRF packages such as the OWASP CSRFGuard.

Phase: Implementation
Ensure that your application is free of cross-site scripting issues, because most CSRF defenses can be bypassed using attacker-controlled script.

Phase: Architecture and Design
Generate a unique nonce for each form, place the nonce into the form, and verify the nonce upon receipt of the form. Be sure that the nonce is not predictable (CWE-330).
Note that this can be bypassed using XSS.

Identify especially dangerous operations. When the user performs a dangerous operation, send a separate confirmation request to ensure that the user intended to perform that operation.
Note that this can be bypassed using XSS.

Use the ESAPI Session Management control.
This control includes a component for CSRF.

Do not use the GET method for any request that triggers a state change.

Phase: Implementation
Check the HTTP Referer header to see if the request originated from an expected page. This could break legitimate functionality, because users or proxies may have disabled sending the Referer for privacy reasons.

### Reference


* [ https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html)
* [ https://cwe.mitre.org/data/definitions/352.html ](https://cwe.mitre.org/data/definitions/352.html)


#### CWE Id: [ 352 ](https://cwe.mitre.org/data/definitions/352.html)


#### WASC Id: 9

#### Source ID: 1

### [ Backup File Disclosure ](https://www.zaproxy.org/docs/alerts/10095/)



##### Medium (Medium)

### Description

A backup of the file was disclosed by the web server.

* URL: http://badstore/cgi-bin/badstore.old
  * Node Name: `http://badstore/cgi-bin/badstore.old`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://badstore/cgi-bin/badstore.old`
  * Evidence: ``
  * Other Info: `A backup of [http://badstore/cgi-bin/badstore.cgi?action=cartadd] is available at [http://badstore/cgi-bin/badstore.old]`


Instances: 1

### Solution

Do not edit files in-situ on the web server, and ensure that un-necessary files (including hidden files) are removed from the web server.

### Reference


* [ https://cwe.mitre.org/data/definitions/530.html ](https://cwe.mitre.org/data/definitions/530.html)
* [ https://owasp.org/www-project-web-security-testing-guide/v41/4-Web_Application_Security_Testing/02-Configuration_and_Deployment_Management_Testing/04-Review_Old_Backup_and_Unreferenced_Files_for_Sensitive_Information.html ](https://owasp.org/www-project-web-security-testing-guide/v41/4-Web_Application_Security_Testing/02-Configuration_and_Deployment_Management_Testing/04-Review_Old_Backup_and_Unreferenced_Files_for_Sensitive_Information.html)


#### CWE Id: [ 530 ](https://cwe.mitre.org/data/definitions/530.html)


#### WASC Id: 34

#### Source ID: 1

### [ Buffer Overflow ](https://www.zaproxy.org/docs/alerts/30001/)



##### Medium (Medium)

### Description

Buffer overflow errors are characterized by the overwriting of memory spaces of the background web process, which should have never been modified intentionally or unintentionally. Overwriting values of the IP (Instruction Pointer), BP (Base Pointer) and other registers causes exceptions, segmentation faults, and other process errors to occur. Usually these errors end execution of the application in an unexpected way.

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=search&searchquery=ZAP
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action,searchquery)`
  * Method: `GET`
  * Parameter: `searchquery`
  * Attack: `aawASwPjWIWlpFPEYjlRNCnxJauVBSkVXIZIdvjyllcRtUfTXaexFNEOIrLLkDHTMrxWOpODFFKmEApDEkmefGNdSDIHeiAmFmZlVujsPvxLjbSQYqgqtxICNKHUMHNHrnbmUevPFXriuZcYlJlamOJIGwLEEijfuApajDBfFGrQvBrDlKrlrtIoZksKALWjJfuNdwlyjpLMnwBqbbbpfpmXMwiaXOxMOOKNIUTsdrIVPyUYZqXPhDwYFkwckEUJNupoeugyKGyiewMPZpaOvjXiqlcXMVkowmnInYxYbgdXSlSfIeynltQDnCGNXoXgPboKKdoEbhiJbLakBkiJDZuJAGbLvvVTqoOdVSwErPPYBnEObSwEkcurMDaIxkRaiOPrECaZmhRJsuHxNyvhoeZqFnZdwYqZlfRUtcHXIhFKRXBDwmApJJApUwNLiOpQbqFdhdwcFUdIrBqPDMoXGuteamrlkTaYpwjuuPiGfrLufhekfAPrPwKNvnQqievshpAnlmasCHtnFfNdhOZEoSDZbojIwgXDLQSrpaJeQOWRDtNuEEciqBAexsNMjAFSCkyrFhWRGnHmSCiiCwCBegPWdpcrIqrGWPdfVdnbcJbPkSVFMSLSYRJoXeYkjecGGnhObqPnwGnOjQZMVAOfnKRBNrZDPdwjrNbUBjRrOndvhgkXuyhcpyVIhwHylnhhiwMPKMboMxyJCojQtjsGapMdkKcGFuTuvQPDsolRceskSHvHmkwLAAHChyMAttfcyyLttLEBsgqsxqbcdTnUBIUeiXLJKqeUAOAYoBgGFxBSqRCSGLamBbpGIvCJBgLpbXGPfvRTdpRQtGGfowMprHpEnRCMwEKqNaDosyDLhjrHKbYpWkEYoeJCZVkxbHDgoWFmXENhDQUeLmvqaqipVLcdmgrdpZuTMBUQcGPaJeDstQcrQrXADhubSoTMZTaAdfuWnaDAfPjQnvcwGBASOJEKUcopdGQpOgYGvETgaovIvbiNrEwGCKVANgdjYwppFWEOJfIBwrtRbbYKQmwgYmqJsfnOBowDomGhHrmkcRqRNOVIvfuLRhlBDHIGwjwujpYtPiXOmXZPhSlHhIaMHSspctjxsfvGfYSQPFUmCvnhbJHmUViPHIeYIyjjQcgJENKdPJNeZKFvAHSMKFbmaKuPyTUnLNAugdYgShAMGgNNXkJECkZlNRRJCiTFJgSjUZMtIWLOGjClTyPNoMHbRbxpFUtDogglwkWZfYPCoNNpHIeSpwJKWqSBhXYVsdNpahKVeqtUQYyZKwumbjrsXvXCohrDkgEDKIuMIZNdMMXyQBimEBeUofCItdjlpQQsjDhDLPHUUgFWFUqKgKcIRrwnwPiNpVZxrheolkDprynWxUyYUuifRvYthIkEZMpcHxtMHMbQFOTdiQPwgcuyIccVcqQXAmQiaGBaFgYkykeIKTNLtahaccCPjSREGFcyUlXXKIjJNNRIMoOyDjlNQxGLEZpQNlqeIBGyjomyimKZlFAywwklFLXNDpeQlUIQZfPDpmTYRRnSInthJHvwolskFZhopJoVqlhVLcpfFRayVrrREwOfjWgfqCSfciyHfIEeqWxGabsEBldbChqBFhRAlSvegcwfXJkahXZbgmJmkdnhfIXqaJxvASYdFuBTLeTNVvAHabMmbReGhpHrOvkVfRTCZoQdjsInSxtuLTuZAJUTRoytIfXTSgEtjaFIpDgWuWvSBNYvCPWEgyfZkSVxcDdINQgSUjuZIygyylFnEEaiuiXuJJRgBXHppYmiEcHbpGlvOBcJJZBwXnWBDEZIkFyukvYEOSrVSvPVQwBMPWicecNTakOcAGbvJqtSrGKkfStWGOHLWIhchQOIQDpwAepMRpcNoREoVTlWXoFlTRpcfWJoExhpqUchuuGQBJafwMPSUZUDcpfcnRubhmmashhrxxcFKImWCkYMeNeEfXIbpodbgvqYKeIhHVLxGqkjRDbrCMDbDvyWnJfOWjhJIwcWgXmrSLFeeiypUhePvoGJRkloBRnJcaeKFhAysNhqPbFjrbyokxAQPEYXkKICZbGLhSRaZQrNXHKBtfwMUrXqJhVn`
  * Evidence: `Connection: close`
  * Other Info: `Potential Buffer Overflow. The script closed the connection and threw a 500 Internal Server Error.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=cartadd
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(Add Items to Cart,cartitem)`
  * Method: `POST`
  * Parameter: `Add Items to Cart`
  * Attack: `nqoYLxCjwfkkeGOUlSSUwmGmFmDeDtcCOdmtmgatmFsExoIfcMqLQACBilnmVHCshwRDClaaLqEGXpAdvRNwxkPcMixjcvTqnfroTNnPSMatcdAbLFsBTkGAbTItMRXDvrhpdPnbGilepXZjKkQOquHiBHSjRTfYFPgvYIValocaUdiRNebNdovNogxkrqDNOoYKfXVWRJUbgUsbadPGXCtNsSCgLTYlPueIUKOTrlSRtnHATJhEAMyASwvvnuVmWIwVXAZrSjtstAiVeXfJBUkDgtPMTJSxbAOQiYedLjBAtKdlfxDdwlOTWdTVnlcDHiNMCoDAeFTPmRSfVSqsfpmtyuOQikpUGeiAcymAuyjswSeQRJlTNSIrILDccjmBxpqcoOmDkPcerJQQQaDXxTAiXDFGjBjNvKjVIJsYARcwYtrgOOaeFNViuGfgwCVqiCTcjRWOljDsPsQwbHSxIdFSKvGWaZFMYxEOOeLZmHtICWCyWIaIGSGkmFPBqqkXvusGMDCPbUsUBXRIyWdpbIaxZUJlIFdFQKrqWQItnNwpXaiYWMTrsDeUdvlMiPHUjGUHsXatxZhlenaAlKUomiEVlGOEDWfqWBYSimPnDklQCsAylHQHsWuHhAdUUEvgusFaqpvRIXDwBtkWVhsgAgnLuFESDPwtlVxsEeJiZWWEnqTaGDqqrmKHLoLnTOsubGLiicNoAckJnktDLBvUEkhLLBtQDNHwCLQIiUaforqgmuiQpdJrxQnpiwlGWdOuBshemoFcCnSYUZRPuwQTLqFQnmrcyaKZlYpmWiSTxRwPtOgMZgGbWAPRakmfXlQvyjxZgsVHKpLKIUionDayZKMZtvsMStBjOyXWklbKYdstrubpMENyZSmdPPitoHAZlGDnTmXkqkSTScjHwripotvJlVkHvQNoqLBAHgHqTFmuRdRAkvceAaxmpQypZqQwBTpVtgyBTFnVvmyLyrmSTQsnTbeumODpONajWBBitjkKUyxoNYUtKNyycDdIVFKvaZmgMkjbcSfXQaIsdZKqNmhduqrboBaNnpDJEXsqGBbFvjjoxjkmwhJfnBBDWaaYkNnClDOGKQJAtRFvboTpNKlcwejlikJrIGpmAsRCpQrmuUHEYmXIZbgVdKBQenZwnEGNQVgBxHslHwsMTwMvlExlqnBLAHOvYUuKkwttkaIwHmUJuTYLZodqwltIhplyHVYsSwoWeKCxPdxSBCCuYQvLRsTJcmYLSKLQtPDjMQNgYLwxsRUvRsCDFJrSyxAmbtoJYyWvCtjAjTNvquwaYySIIPwgdtfkUJhbolcxqlpHukDtsteKlaOMVQxxbAGupyPZKpXfsHbRjZgmFosPSecCYCSSvssVhZXEKBZXfaEwSDVEgbXtHplXGbfcxcbXhHrHaIJYOAckDsKuRTZiaZypZRSNubiqGFpgagJJssApPeeNsRMryaCIRQeTKDGPqUlFqStJWhFglUyBBvXZLlRxGebchPEXCNotckdoxevUGmWqyTMhMcbZOtafhpKeuNYOhNQSLWFvwCNYqcXdraCsjaYTHrKYZOvbIPUaBLlHjYEFioTLSkiKKWuquxNlfFPnRqsyOXhsncQoEyuLBEltlqWYuqpDqblopIgdTmPKtfclXSAYlmwovTTiuVXYuOkOrRldYqqYGxasehqlUHPlCfVJKAGLOEYWnsHDlfeLKasyMholQlQeHTOGHDCwxhftLMLvMNjntpWGgZZOkjDvGpjrHqHCZRhXFaNoarfSevmyGQCkHRfGdWWmLXmmBBgTPOHSatyiKPBACyPgAyDKiuCbrnXespKuRdtKuFZQufkInBhOmRlCkthYcglxBeTmuSABrPmmPldkGynjxYvVhtYnTSqSGnWqoBtCYYNiGGduWuHoZJKTVRcxSEyCcXtMynYQPXIRGCtBqmiZjCSvPKXFBlrNyfydZQGFIdqJPBcmpLLbWtgaLaPZaPPyGHRlEueqkeAfYSGjtwOaHwnAbrhWqxiiPkDopZygfdqvJVDZnTybbhyVlNsQhxLQJqiINiqRGlCJQAHfpPVhRXlQTQncjLZsSTnNnCUqgHpdEHhdXPDi`
  * Evidence: `Connection: close`
  * Other Info: `Potential Buffer Overflow. The script closed the connection and threw a 500 Internal Server Error.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=cartadd
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(Add Items to Cart,cartitem)`
  * Method: `POST`
  * Parameter: `cartitem`
  * Attack: `SsddfZBlCPhNamNoKmEdwtCkLwjsOIWpivKICLkTnVnPodGHwNmLwDrqAhTvXPsJjbOuHKYJmKXgdrUkJxlNMShYFwZqisCYaNHMJFMejXtACenknwemnPuFUpNFfvrFmdjgZWqxwJSVlPQIRlWlMSvUJNjlwqLSNbQliAAMNdDypJEvjvVNxHMnKqQxagSXwETDTOsWBYVyJnOeWEGBPZNhlaTOaYlQkUJKepACdQTFHKsRFeukyJHuYMpPWLBhfNYxDtgStsKHAvFohoxcPyBkdbpJZGGyOiAVmCMNfjcssNLmxplEqLeBoOyHBqmupORumwZcyrTCQuIgWirnymijZfSpKGEphGlBhHowyGDOvHqYKESvEKrXCYLBWLBNNNMHWtggHZBRKSBsooioVEuEgWrHHkWZscyiLQyfGNdsCbbSnEGIRuLyJhxZEKYxqXsYBSySBEYhGpYUUVxLTifyhcNoaXwCXhJkGnduoBBoyJYaoZorUpyqqxIqyNwCqeOSyXQtnIyAGGTRYgPPLgqwcekjQEfpwTVWgRiTDNeeiTeCOoUwYJqcrMgrJDWVodBwewmbiqPWenWmcUlgfJGRFYfYrsGLKFfWpjqnrufcEduApaYtWcHDUNrlNXdWFYyycnDmiJIBlRaLADKRwTiyKpSAknbLcMdhSTaHUpWuoAcdHKVaByARqlojsVOSOvjbOtnhKACtfEXjNyJCiDZGOmYsLJqHASgrJYaNgSQqRKKwYFIWSuXsJGgcRrqUEHQnHoFxfiATpKtyjojYYxcAuOVDyEdhypBxirChrODbYvIYlRQQBFuxCeJXNhKvEedLdtqyopqnxrcAxijlGknFrmHXBTNEWNGrDXKDgXLcDbuUhDZbBFlrcCZHPDBcCuntBeiJbBEaamJCmkFWMOPkqkVwbMApRrKKHhRrZMPjmgwMDcFluDssFMpfULAxQiQvSFbOdORRGpgeircuxUWDaOkMGwYoEbCocrxjYKiWFDxGVuOYuStnUeJwRJIivgcEmiaXyEaBwUClCFpVVrGmJNckeZVXFiBPdXLdkbLpLDwYUwGdtycjlKxHyElCgQnwRRZTxEBvXLIlsdJFoyiKDApSlTnRNrfVeLrCoeHyHsNpMOHBVaONUXIiqgamrlmBbQGsfYQeiocRroKceeArkCvtWJgZkYNNqmMNrMepOfKcWsFdOEgrtvtFuEmZJEstjNMsgcnBfPuBPlltqOnZMIdqVPqbbQsqxbIMfhEwoyYOqMqtAAlEROSHyJGOeGZIXlTjLTxZxqqFSHNUxITFIxJfDhkWeJkcqijWLHgnYQtBCEXARgkbGTEWWvRgGCZhyeuYJPEIZrEoSRJKfOcQDhTqdIkUsFVbNgdceIqmDwvsgfKOPsQsfjMPYyhHHsjnLYArQHocbjYMHVJUkvGJPvwrTmxUoOfMrliqZHgYnhThVKkgEpUbojeLHXbsUQaQrNKlCvBYhYpwPnJyWSOyqfmCdQiJsoiJOkDZhEFUJjpuqYLEHiQCRsYmxckeZBVcNjBEVinVgPhJOYRDgmHKrhwAQKGqlypHRnGWCtJBZsxAYPfUpMpidjmTUQjRbExKPZKYkXJFLnNRoXVQjOMNmMCRgeVmwYyciQVSDQAhmpZdIBbZAcnsIKrLRlXUyNLSCTUfqMrRpkVhqOelDJqocwOihCkLWWrrvgfOhUaNXfXTNyAxJnhKQgAPYbqKUhRItJIJodjUZbMZBIfETlBHVYAGgeOEbGDVSOTXZmAkiMfkyOOcfwwQMRhaRiOQAuMhbVyKKHkTIJlwfpYqagIeNRfJtlIIfeAPtxLlPlpfgnguSpkdxEwTyFMvwPRmLbBkmJAQIVDGvFKjWophxEmecmWsHqcvcEcNSTUCSfqfmgPDUyBDVArjrJaeIKZvGBUHkPWsQANhtQAYmYqgqvXbNqCGVXSyQtcFdLXhfXUSMFBYjHrNPocVwnSQHeFDdyTpVJSbfAEHUbGIgljuNlanLEykKtIQUiWLNkLTbvUZOrAPxmUmLZUSGVtRtZkFvALaYPkVKshXCutuwIqTjlnZVOPULouuJHvymHifaocbCBMrnFPS`
  * Evidence: `Connection: close`
  * Other Info: `Potential Buffer Overflow. The script closed the connection and threw a 500 Internal Server Error.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `email`
  * Attack: `OwkWSakGUdBZKMqyqaQmJxAlYWHNXnSBfYbUNhUEuJYjxpiwuFDavgtGIBdTHHvoOSFPSCEFXQYEVdsLOygiaCAwtJVCTLDJSjpZZhIqlIySEYpSJuEWJTMydSpyXjyxTGWuataYoxYuNQcnyexIOepvvJMQKIqmvTFrLAGROkyXWuVOtSWIVZEdURYmqWdIYPDJjMiTQobjhXeHEhdYAaTowttGeZQoIiaHWToZKwFsHhvdcRXgZqbxFIlqhZEClkfhhhwsVyynKbvGNOvLiUmlaEulihYWklJluHlAXDIdsCmyJbQnEQNiKyQVFVFBMTSdjVuCCFLmCZbZlsfcMRZylINstqGDRYpIghbVLnZXdQSEYXsDpVqNBXJwThbYruqfIYHtkWQuUgnpBBgOKoapoXZjmDYcoivEsAWDAyngCDigeRVITgBQeBRCHZTBYrmSUUPbTaPLheiXRTmrymyNxTUAUukTYxLmFlbnKquhRyqQfvyApVYdFOMFmFbNlutZJtZRyIfsCZwBSuYcoqMePOgaqjdOBLwmIHiWHvCYttxqQswxmmqyFpmDViooAFroiWdtKIfbSaFwDwNOyBNVxfSsITrcOLjRJqkRwXkBifuUJvRsTwlvYYmfaOOiWRNFkGFbjbnSlnhpMxbEPOeUVGqErYMWrdBPaScSLLjeirwnCpMbVOWZKNMBfNHiEVYqwPgSrirugWVHFQYtiEjqOjCRZmGIRLyVatSMiMMgdkyecirBqwxpWUFYmDgRXyRCTfwWFWuiKINhXktrPUciThihFcgIHdJPrBPbIvTBfYDvLoOwFMmRnqKbwQtkbPRqmHKAnXbywflLuVVPLEVkduRFmEDpDAEHrumDTGvHPmeAWCBKPWpUXeesLBvaVOwwRBMeHfZtTcGOgqgmxQQYyxSEqFtJHiGYUiQudLVcwvLpTYQXXcBRNqjNMpORdbxKrcDvHbpYjRdalqAThZZcrLXWWcccSpiuxECHPOpOSGuLZXgiXwXSRoYxBuIZypFbPxRDZvJafQLQVtOXkgjKrusLtZpWTIWQcTYLvSwOQwJaaeJBRHMUfnXtiwbAHDoijapCsTnuVFpAAywwKggKonEbjSNENeHXhFAowIHqQHGQPjGVrlUsOUEqGnwJsSTNHXOWAbtyjECmSDBnkJaRcTyWCJZDQdSHGejqxVemCmLpxPeGWtXYIAUBlDifZeUlNXYkpNOXHxYBZwOgDdRtEjKsNtBJlswXsrSkkSSEuWqepEmwfogyIPRwqOnZYTUKCCqWLaCOZkWUMfeSkBksPNxKxiJNoyWQVlHFlsAHUFPpeiocSQWMwghlqtZgdqQtycmwwLhbfgeKqYFmJFHWlfgcInZGoRJRUwgVdYjlRdshJwEZFlpUmjOaAxcwAZdKKfqSSkQULDDwbgFKiFlFILyajRQNUmSmlhjJtjqGXxJNViMdnMyAFHrrQJUIqwTaZeCxjEoDWhZVSJJFhIURtLhHtSCoHxhecCyLaXjeHLwhfrBvpGqaxchXJbFgqmBDBbPmbVNkCXIofQZhhXXdjrKLNiqoxxKkCLYljlYLteGCWgMlDJEfcNVewNjepIFJhDTnXCGNyIqqpGYPNAxXldcTbdFwaWPYYxBxmOrSdTpspQjFvcmWHCnQmnZJAhPQkPbghSQTkVMUVBLdtuborbxiouEbtWKrRHEWeCJNiHcWNpqFKkvTNDFisxbUOcebhFmWqsAhDbvFEBFwGJSWLaYmcubdqnPJRRTPtgmHFnGfpRKxnoojYpuLetviGxZllKtdAFmlXCCIMZiTYjWRvCfFlDClkoVwZqTWQOmlfWPqMciUJnhsNHfkEoANPtnFKQLYtITuNncZIocCPDsgpboRqvIowmYvYeSwnwVdWhgmYogcuHgEbKyqUdFVnrjhmQevoxVuCfrDxIUAtfVWTuOBZernVjFGCTJrbgDpQwclxHxpVssmWgGTcCwTDeXVjcTbjkDtCbOQpNeyZpVgPjUUdGWhMwpUTQKYImjRxpMreTsxbypOLSiOjjaRGDFvcxFbmaRtYhKrYPdNSUEUniMsjqONataTJVyqNxOulcFHvOWf`
  * Evidence: `Connection: close`
  * Other Info: `Potential Buffer Overflow. The script closed the connection and threw a 500 Internal Server Error.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `fullname`
  * Attack: `cIekFYWnIPrkFrbSKeMOHHsiDwIreXmONOxywVjQLJgKYMkIkXtXHupChSYaLboFHDJWTGOoXChcRMkKKIFVKjFLNwyhcZMDOlRjIvfPelkEJaDhvLwgYQMChLoUhqRJWMYywlKWcqfbukORrxdWEcBpQCDDNpFaDiYtvCwDaYGhbXfdfQMpPsjofZVRXpeGimUleYBaGpSPatKEZEUuxqkwEWRgxWTMjHUTaQCaqRCcnSJYGjxUWrNfxQiqnCUPEuHwgfKcbNYtkOWYPVioQGeHuRfpjSftPMvQyUgBXcunCfkuOXWvrMVRCqLkMNeknHnkwYVUDDyyGVmTKjQnipexZuCYvmdfLOLjWtKgCoYxHCnVkcXeBbeEPZdurGUmROMBxSHOKMeUGpablLujXvpMUUKTXEgGNAnwPwCpenJkjyFrqOceelCIPbKUWCxfcklIYJkGGZSmKALyVIWhvcvZtVAaprAruajhJfbYWbxYPdhpaSnnjoYiUySceMtvxYKkIWgJfKWXWAxjVdpJZPEsxwTbRFfveZjQbUpOxnFGviQDNKGreyEwfRALaBNAHJtuljbgUnxnxVlQGROCWFhphBJPqxlMxeDUOmiSdwxdkfDhATqlyBaWxOZGLWuotYuDIMxyPqNTOCfQrrBxdoBLfoqOXMLusoRNGnSjCWSnEXOVLXYNAZnBkdSfhHUlowPPlliglNNiLklTrnxunqnHmfRVHlLDgKWSTdeLbkrHlGrurKuflpVjocSmCnDxaMIJjRvTuatcWBdxVSyBMAMbOEKyTYlEroKiRhxBjnVxathhAZcLKCoZlxbIZuStdeQaBVVMIcwRhorZODpmkKNvNMrKscRGMbAwttmOKmMqlhfPurKORxvucqQejArgEdvksPUggDbZTaeHVMuwqmluddDALBFQRJcIDUctSyyJdDmqIsxKffsTCwUlugqFwHVTqdaDtZQWbTJeGVSbeQplrsqDpRpmdxExkHWOvCSGxPKFaPwekAgvtKqPYZSKMOWvrbnHcksFiNTflOeKcGCyyFmldUjqxrFsPQxysavKAZswKsFlaTpcYtohtsFCoanPmZgFIETwsEjnZhBWKenZvGbGNhZIxhESmEYsqxmfQJBramlwJiFXWnZZgtBPAMUohuFIXddZtmGOTLPvLsDtMcjQvrxWDpFKTsamUKKlrUaNKJOlPCQCVVXaxdySDMHjbtsmQdqxOMAvVyXrZwPiAqidWkbDacAHxRkclsBsDlxZsFnvyXGCoioIqGDxRuZgrtqJokBVDrhsthpCkXimNELOHmOXNShvUBcZyIFSscuqJcvMSfqwRDeKLAZCuMsRFtrCShEmpJEckLdHBMWdwXfYXKUNaYZQgBWYFddGDdZZlDSwETCouMEattrgGdsoXFqkIpHxyiXjAQyCdkCIvgTUZOSXWKwnjrMJNhTOwgvyfsAZxYwnRuxtMvJSvXDpECxcSRfugseubrgkLfOYEWsxnIqcYPNcSnewCSIhJBgPQIkxsXBaAUtNShGQAkhJeVQSJlbWotTWYxNGpOWUXOZWTxOBbEoZqSxlNSvNCHqWaeQyxTdpIcGGoaWIXUrXfXQSrQgtyaoEVlLkbYwTraXXajSPHxSbmwlDkhCcLnhXUKcnJhamRGGbZGDWbMkIDYHarvqfYNCcQCgKNSmUeBoRlFZgjixFpQjVeGceFqdBlOZYrFPZvPVDtLDvrwHvqhQeWVcdjoaKoPeDZHASShnpuTPYrvgoSlbKOGEmQhWEEaoPULeIhwYOtuvxKyRfSZvluQApgFCGCYnQEwcPaRnAyHgyDZxwIuCJNxlndVvEPxRFYKUYNhRsYJTiFRCjhJwQuLQLgDSkIhrSKTjEuAUnhoalhtLELQNSCwcrcAXxspQQLbOUJhkOyCUebVqCUKvOAHOAjfeqVYwxhPQFmnaBbAsOyKmaJNvgFCACjjEasVnevcWaOyeiZJVRJZbTabtbdOiTcymIthaQtIFgEZpLWJfaXrUoBnmPbqUtMTCXNtumHLNDeUEYRMCScZeUYnbRiJJooDJKyeNjbgxgvERuadlvRrIvmMmCHgjjIJdmNpEb`
  * Evidence: `Connection: close`
  * Other Info: `Potential Buffer Overflow. The script closed the connection and threw a 500 Internal Server Error.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `passwd`
  * Attack: `EJZLWqlwmtfgMPTVUNmUdwBlgbSKsYDBsleIlFJZSKSCwUBIoWFFIpiBeYyGnKMdaBaDKnpSjfpTaGfVHsJuKJnyeWaaTCPbWHEuLVyqHXItpfJkIakcSFTJxvVVyFihCcyhSQpsyIKKboJfBbWCpDBwmUFnGNrSbUeSkOHwjpSLpVPjdTcWcpkSPJexHhSeIpGONLWSlrXFimCbJvNFMakTYxqoumiDgNAHnOwHnKqnTpFZUkArRMdZlxqAjHAgDTfmmtUKylmbOcnvOLkpKQeqdLosNwowBWyrtwZaVpEsjGjRotCfOsWxRcRypCwSgiIrxZqEATXyIfmGcbmKGAiGunPmWlreCXEOnlebSKEdejSdosXWZrXEWubOeMNOSIiRoWtgRHOiupDvvZdftAhIyLiHhXrFQfpBVGnTYrkpeVHRaRSUPHVNjIjNgesoTAsKWXUTIkcuwbveqeXfIHuKUqnOfRMjrfFhTBAVXaHURLtbHTwkJjaFpHsaMFesKNcJcWFCTBrWplBjjkWLUFZMYHMacUvJPqZAQaoIQvDIvZEAoODvbVJJNObkAWKZVJVviDnAvSAThlNYrPHygbnhpoLJXhymEAayTKCQvITNXDxuBmEBVnwAUwMEsUuKhemXKvymuHmuSpZJVbthnIqPtEbxXbtnDVRqkpCYKPGsekLapAiLPPnhhmUoKdvVrbkKFsbrEvKKtAkXjrdctNcYFgQbssfYIkROyORYRjoysJCUWwADvrlBLEiHasYfKoqybHUWMemFCuitckmyJlhXCeduMqIKRyiLXLrNqFlJWPbmaAyrelDlnVPQobBQwQZNtHfxnaUMhJPYPQKdPvjDpDDeUYfsMPJJMKwWLGKGCwlMTNpPjWmrsWyvCawCKCXyopBORXpovRbcBwHLbmgwwhVwEpKDJBlsKnEaMSXEsheHgEtMTMxUnpFdJjavbvxJiaieLZqepNvmWdaxYZiUGIBqHBvpvjyeLcjtLlLYSZlDtVPEFriKJVTWYygqOpEgacOHpWgTIbHfhMucJhptQvnfweMsKaBrZIRmUgXamYlteVXMrAGVitBxqOgkHEtXfLmHDVlIdroNgxhZLeHBjCtiNlUZjnRPxfqoIBiUmIBWgyUhIRnCtOAGaqfZmhPElTLYrmKPZNVYdnJYEBgAKRdEmEVXXKaFKmIAMXMHckFZuolCgGKyQdZstGVLuZTHrUyaGTMlxjyBqVPWGcDPxoalGBJPcKHBirIqAATEftmBFxBPgQaQBEKocKqRbvvuOfMMhwNRXtlMhhSlEPEyPeUeoHrdjGHdHQJaJQwYPmsJCpwceTgAuSIZnDfqQtAPEjrDDFGATYTaisSMyDDcDQsDHNtcDQEoemLAOsWcPNnouJDRruvupWZJTLPjQpfntPCmpcZgrCYjngMNKRncNGeQwmXoUxxcmPBnpvxnfGcgwVAuSBYZIfIipykLpExJMERSXLkDoEwKPMGDMayrBNvfdZIdakBmZvBxsBVPQkpRdGWPLWwrhPWqrSxTwItKQWoOwjfeqIaIZZvRRmFsorYntXRmFNSyBOGefVklEyWOQLHRtiLNevgNqAPiQmXdtyDYrtMuHOsfpsLNHTjIDdYZQcsHMVGbMmbDTouuErdagetoisvgpkQLfJLMmHIRjKIjylpJwrPmiWyCBHVAcPlSXhQTRIdRAKAObLhQGlvFOLRhEDujnOtCRhJqABdlerpkDAcQoBUKWmgSONyMXQPGLBZNVYAHRHHiJHnkUDAXgWNmsIwULHDAbdrXPWejvmsiCOdWLXIpOiYhjQGlcfXkCFhYvliuccaglWviNcFjhntLGVYrqEKQJeTgErblLjmtCisYjcWuBqUWxIENcAqCWZQoABNriqPOncPQjDaxojDpAIEFAwwhvttIQQVYoAfgBGWijPdpwYRbjkgBsxbPfuLEsPqMraeNMrpNoskGsIcKRrtqEluncPqTZQHZjVuZPvcQdujVwCHrxxLitdGEnOdKKrqORLpEXuLcxWLPtoRhfHDTrFelOaiLPBtxdAnRsZhsTKNDuqNqqpVFoQMhHKvPWgjeGitKiclfoPqflQnU`
  * Evidence: `Connection: close`
  * Other Info: `Potential Buffer Overflow. The script closed the connection and threw a 500 Internal Server Error.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `pwdhint`
  * Attack: `RMbqnQwwSaALIBWgKvnPQlTuUSUoeTgRlRIsRQREOLOMhFEZeHkAGPqeqFkSyufaHnqehRjtFCJgLwvyeHdMgGkRqvGFoXJKcqDMaHThMvmnGxXCHtmCowFNDBRIuwXcHWVlMInwmBZDggeBNCXQpXyiwQLYRRJfVJGgqVRmHArysZZpIRTGLkakeVVbGGmpSUHyMNvuwYcyvCUKcAnsiUqHwnrLyicSeMxUIMIdFJluVLbdEJNtbMmVnGhsMQxUucceHfPpsuBPOPkIyNeFqNjShYffojOYOLjEPTKpHpmLXmAvnfbuMEgBrIKaGDNAiQNeDgmwDIkCXXJbZfuSHMwoIXplOtJirNLVvoRqRUWmUyAuTWTAssdxwOXEDyWSdnHxtWDwMbYAkYWjmtdgMslBCUwWTkSBAjCRVGfDFQkBsGDYJnarQNRDJIDnaKTxBLResroPoFprPnxxIunYFgoqlyrlpquftlaOsIqnkAcctrrKBoYakOBTuWlymTgdxiytCGxmdwdgIEMHwHeilmZvEwEjMcBifQscRNTTAZLyPImFOnfEKvekNEtZgsiaHbxGHYLCQyiYZGRZnaxFcbtqpLghmhPnPKRoyDhjQUZtOhCmdDkMBuNMRjDomkErYfGOsGIKdgrYGYkkhlfOHKSdStmYCfoJDgyMWIRsKsdBqWKtDgKKVDioDkxlOVIdKlFAuxqKlZtjEsdsMeKaLjeFsOOUZdeVaoZFDCHCCbaLKAElZyTxnkaUprnEBECtPWSZYSSplcshaoXqmQGtnPcOHrNGFEVqOYmrwtBBHSnekpBdOLxZEgttQgIAORcrQNvHxYUwAcCgQJaEaaRwNCLeioyWnpLxJXjbUPqJVZaDUBPgbjgxfyweQidsNdAUEhgPLCifLOBedXkEPMVeKLIQEXuagNQUqJIgKgExSwjbYIAtLbceSJBLjFtkbIQkrZqPPBWVSslVcTIBJIltYiJbcbYRNEvCqDSaErqRoHBOXJdVKZAgWRldXmkfnlbuABcnmDtiKcZyABFETeSDxEGPmsneGCovGEkiefHvMEqquPICcKrVoFEGsEpwTjptbRGDaZZkAnjwFyegIanDouVgPJkROFYPrsKcCnClWMDIGvjljkhjQpKBxHydJKoNhRgmBuDPrNExYbZpDuGqPOnUSOtdBhvdJeGDVCMPygpKCbmtiyucZsACgZwZnQpVgUAFmYKJJKNvMlvZQgcrjkGmeBCnwjSUCHjhSPyxJYciYtjNOuhfrZleiQLOJsSjgDAoSiVtWeyPMALvLIZiignmdwAqxftSxCaZlScuUIOteeactKSCSsMgJdojNdMWRyrNBtYPYtTfgxReGiNbnusRXFffTiameprveqHMIkfJKZxHWJrtggLQUMbpKyLEMFQHyfeiaVNmKcMvyEgmFppaNwvMWPltioqARxITeQKPcOLJtxHvRMUZGwZvvXMwxEeetewvWmLMuXlhPFRyqQPAisVceXyYhEEIcqGWnjAueLwhNMkjnpADXqqvqLqwyeSmTaasbTWMysyLPySfiLEKhFwhHCSajeGQyAfNueCmCddtVecNIVXMVMhmAayZoWCnRhCIOTQtwyXBhqevNarQSIuoFBvBrTmJwHJwwmDSdQBVUaHenAXbuNpiqsQSnoAqFJaFOGEkOQhWPoNTjrlfSKlOZfBvRLErEPToPFeKTHytHxjDdTiXsvRpaXblrZkPNwCEgeHGnEnTBfQIlwtkQmWghtSbeaeFYZEbdbxXOxDTySOkkhYVxQmMJHOTRehosiCMQZOJArnsamiMhqTBElsawBNsBjUZjiQjEfeTsQhmhJpbUosSmRCjajfMCtbOGgHGGRHotymGhyiRIlBXTyUshuCnqBKPDBsyFUIMcVWwNotrKvHPQsLWIUIRyXRbvkArttscjBaMMVFgsFIdBBlZQSGgbfsEbgCIJLhRgepDxQDIlSRXHMHusJxqtaicoyVKpERNPOYxuuipCyLhfGjFfPJTRfSsTbSUutcUIlqeYGHdXlUIhbmTFlTVCdrXxwuFSHKkyHojuNIQhJQTlhmgZZMhoiqcJoHeJVysYEXnBtWn`
  * Evidence: `Connection: close`
  * Other Info: `Potential Buffer Overflow. The script closed the connection and threw a 500 Internal Server Error.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `role`
  * Attack: `MILXUERcnTCKItRBJxePpoFUixWmwDPruUNEOMbsXIoVmNWTNTIqhlFtjGPPXIEPpZdFbwWPBHrdwgHTmbasmDSQRcOHpugqiRoZNyvQsXhteSBEHOWwdnaGttRqQtSpGSssAJoPjnGckNFJyEEpcorHXlQtAORJHblRJqlXbCxaWVgLZeGaZaLFhOfsxXJutPpVeeGGjPUiEpqIbLmiZDtxsWisKpDcEvNxWmaQtUjZNtwVluFRQutrQRZJoCDoMfJhbmmPAJBQrkSyWBvTYeIbKiYpgmStltxYPjngnmoxBfRDDtpdeUcJhXAJTDXhFelsVnePRKNjUwhysNvGeMmaVPEOLfpjjNWcKwlxcsKXrREFdEtBtXtXQGYSZdELwREwXLCymGydCjnVfYhlkWxBFjwbRCcahZpsdjvrQAJUJvdMZPcZyrxVQkTdtKkFrMlrGXHudxJiYnYbkXfBWMsvOiZQHdGRwGwiSHGWRLZHBTeSxuReObBjEADKAIxxPlUelbEEYrLNQoAjaPHuACBmZSjUWDMDkWmMKKsmmfIyOuAQawrtIevYgcFcXVwUdOvbIGnvQlIgKfnqwxYMrhGLbvZcMDpfLOHxRnqVdMtYmACkokmbPYIIGGJFDGaVtGUtNlHxhLTmewfvQLWxrvegBAARoTmPXUUXbevTfIMJUprnfmZbYcuNVcJDjuAdqEZQgGVQrxKCIxJqdsLmCbtGKGCwQBFhwOELRNNeSZgtQcIKGmLpHQCUNwDcNhQhfevHuTtBbYTVUVSwxDrMPODGPvqwfUiGPxiaDpuSNxANMhOiKmuaGJFKeACnMMhGBjemEMloQwcblrZOPwSHJhgDWBGdiDgZsWgKyxYwecTBZSeVOpdLCEKsNRhDkSyOAwddlqURPlivTmtFoxqxVQDpUUcWAoeeAlENSiQTVxtIAZEaVODRXAmffhnYcGZhQTaxbVoshJBliiJMQAXWlfxrqKqcRxYlOOemNrJcTHyClCEMAnAbWhhWryeipqgPETkWeUlxfReUaWmCuWXwRNJCgNbqKgupuklmLSMUwvjumIEfGNHdrqIZBYtYDLxqkkjvAjCnVrgJGkJUPOsNCqnUSJYptmfUViSQTREbddhkLgZUSGhRHSjYARPRxhFpWFnUaPoxkQTmleKtVENJpuLMcOwaidEwbqFDEEPtBkqXDWqANCcbJtAbcDuCUfAjXyKEKuwnmmcwRcGlVLcmamnOqIccaXsZmAfocDFPTBlpLMFwUcelIsgNKZaTZakyQLJrcoCYwMLdFBCJwOtvvkeuqEUYBrrCMGEnjPoySZVxAiqRpExbmpLGqtoqvBPIGvVyRbYomSABsljbWjSQeSWErTbeqJJgcLZvHIkmLqZdVybLsMHMHwTZExMvRJwkUFBcgxYoKqkwslNentZuZuXBOUZkBrSrdwWwiGGmShvOGyVkvEnLYfUDYvIDQBnuMXWJPkMNQcHYCjxHAGfOPHdfChWhFyEOKeljqyUDOTaJuWQwyXNmsMMTDwpcVKVVjckBbglUvtdBPfbnvwrpDeEECfZvpKeiSqvYiQJWboCyJNtlXKSGhnCSMUxRsgCpwgYoUwfHCoHJSGDJQcRrrsdjkEySYyUBoTbvpdJZfJgGhAoginYThBNddSwdlLDBRZMMqqGHLnflcfRIwimpAWOKWjbgYZFIVWOtvZqpuxjnKUMJoEbYaFDeciSTwsWjZqNGHcIeNWpDvGZVWRlwDmmKyrRitpjyJDKDNIwAkdwjtJwfwBCeYRcIrpKrcFtYtXsMmmfNTDhtbLtstkPcSEIKjuFLILIJKJFkVLBFpXlbLXAGMkPoAaORJfuNdjRBBZQYdwOLCdWlHHmoEHsrZNGMWMaaJqGRpEGLRbpdlrRnRyTdDILaxEDgKtBjtwscSqUDZXqPTfPJcZjGFisLTPSAvrecdSmlYNwwHFxLlWHsolxhgFoOFZfamZbwLGIUkvsNXxrWVBAPgcKSqbDKHkFTJStfmHCnwbUNqvfJEWyPrerDoRSTZHgMOFsewwgnqyhbXHJppwkvJJJMgAOkqIZYnfYoCRFoaqcBgGEmbdoPOmZGUvkn`
  * Evidence: `Connection: close`
  * Other Info: `Potential Buffer Overflow. The script closed the connection and threw a 500 Internal Server Error.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=login
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,passwd)`
  * Method: `POST`
  * Parameter: `email`
  * Attack: `TZPwvMPkKdKQYOYylhcwZobIKWBvYwFbgeQndJvURipCMucjnsFgwtZcWswkTEscgIUKGLyPxVuGmFHJHnefCYejNBRZkfmiqFAJIekRIQfhltUhsirnCArIrWuLKwIgehkBwfrMuhWOGVXGApXxPXLMdYEZMwcrSWhqSdlbjDBoyIAvhRAjPixeohKAVQcxJdOEGaGsZaAEObJGMSgpxgKGEPYXaTCinFPQgqgpSsyIZQFCygjFjyYMUaPwNacEsTTZAOHQHJdTUQRUmbvLdkUYxwqauPPmhUUIMiTwSswvZjQYnSVSbwWYXPOaifpHeuaZFNJrBLenWmHRfupMrklYfwhrLcbylaDlNOPZaPkWtwrHXqxisMlbsMTYwloMeGPijYgFQrbcZgWYenvCoURrwWqbtbDnYrmWEVIcbGRrYGOKpqjELrtrhLqHTMUCZmBLkiCIGeXASeEBSUsJxfQJeqtdsPcgfwghaSPXfKCcniifKiYKgxyiYVPuTNqwQOfdIsKsrSlUlZZvducvLkKrLmDJwVGkGiSaKMaYKDRcLWFNvUBvfUwCmxbaAMWDFqvDtSAgjaagDrcedPPFCTOHPukiITZRiRHfhGyfqwpGODMtnxtRDxXtdCaedCiRCqGSlKdSjqdQQpANXFfrRCWOQmoRUGuwtTUQBowsifwAwnDukNCKRFbVFZIiJEIoeDGNMoYZykmFnMNmIGPSJUnDVchuSklIDYEIgjYolJwbJBwrglflHWGMCufVqyakrHaFUwtxfsQiqtGuRjLlWVrTTUspGXICMagtEXUiAJlrkyUSNlDqTmmeHaVpTFvyhGhgagMILxJqPVACPDsjNWAeZWLixpFOenedHAUUrYfEVWCeWKOgYtheJpoJpiEOMPVATTiBHsybcUHwiqwvaiBtIQKmKLExYFlkeRYWpVkUIQTnqianHfjmIZhImnhuROpGprhlYlmdWLQbOyWvmXahmbuOPHsUfcRNBqdnsySAFREATCCOsTHTdcEuLASTyEThikmRgRpqNKhmyRtcNwpqEwusNRFtatCsdxmPhYbCeOcuceTbqgQdujxVpmpEcWdOXgqoRSnkVxsXynSOGpWpaoEFddkeAtxDTfLSPtLrCcDmubHICSaZUYQpJspWEDJZnuujuwpyXIONhelHyIHWLeCYdEVGMDgidhRtmfiUVjYdBbXwjLkvcCLOOYHAaLOtcjplSKYIbRBSeWFwxkofDcjCyJHRoDUtqvuosoTcLSYtAksUKLLwDGKmgDQwqcVQuysVKWGSqciekHJcKxUxBsgXSVXCgoRSwZnkjMjpMQvZfvuxsDeeCevTFxyIqlOEPjkfxUKOaoBCPxCGtjUnWTeWrPIPDXMeQZjTDLbKwMpuRNHJlrsOUkqnWclKcGMFqNVeCVxfBYcrlybyAquGGrIYLodgtSuSZfqeHaCcxylgZxcFxkuWrswpLJVaNKQeSHYZtGlJTGFRPKtcwmoxbIgVJgBdiBIGwyrRPorqQXQDZLFrimyXKYEkVlkVBKHZPjydwuykKFipbHybJVgCELtRpTILxXkdBdRghuKbfSiOHnLPXMQIEaUXdURNUaLlKdeivJwjnGfamhiQEZulraDAKgusMlkOGpnWlBHRODDoQwGWZPdRgwsiUGZXfRBVWKewvOReQysuTEYJEELIkkGRgAADyuqvIrxEJTSMtExillEHebsFUrYvdkVhCSJSfRGpkKGBXTNDqjyBDvEIOyIZafwvkBsaEXFMuKPXLVwciQcMhJumOdDvwEECoRLufgfiWYGHxcDXRrRSLykaOwvTOlcVZqcXlMIpIRWXBasXLWOeZeafUvEnKTExXXrvPrkVEXWmPtoGreOLkDRakAsdScrgFFXlJPlZjFqRxOetmNwYSXCaiJmGjVMbRKpWlHUZdSIIPXBiBcEOCDJZDktQPuuuAYfNSRmNVPlwginheOWoTAXLQvInfXtuiKwPRXLLYUeoFNwYdmPecogTgOvURposfwEJhGMXIZCopryqeaSmaLcIqDRsMmGuSNxINTWOKgfjCJUjccQVaDLVrjJGMMDgFUXTNqMliQGqicFiieXp`
  * Evidence: `Connection: close`
  * Other Info: `Potential Buffer Overflow. The script closed the connection and threw a 500 Internal Server Error.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=login
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,passwd)`
  * Method: `POST`
  * Parameter: `passwd`
  * Attack: `TPEuifPRBYdPUoiYdfXCSWXwsAaTYmXhFFyaQmGQpKLMXrrnuNVYOOojdeqvJPgXfgetAhPrNJfDmcpdKtgrFlYdAovSNZGkjNhPXVhblyFfEfxQxiWwwHmghjCJfxesVEdQPEqjsNpDQXUHgiKVlJKZGYrMhWaLtFtORHGBbecTolDrRfqiIDlSPhapxdvXWTOfrnGbUyxdwbZDNXYcLpQdiekQQssbQJPuZrUurXIJCpGIiccnilcPmHQWXGbhkmbtNqAVXsTitNgrEhXmPrbqbOkJZVMyGLuTRJXbQyfomddigibYebvpFhXQCPFbeYeWAPRnVedgndBnGVyIABPfkDRqtxUBwNwaCpJQPRtSSFgaksNtrIVPYESBVsbMhKWUuflKxetJvKxXmGLcQFimdgWSTDcqNuVqQWvOqQpbjbQArcQaaplntMjJsnHOecmxKgIZpxNwPHGYKjtlqyvtdbVheICfEcATAdiYBoowISBoVkoigBxSIfhfTciUgScrGRogUtXdUNAZdlRPgsUSvEWdgaaSZdmjftWROGmoBQVRvneQBOvRMlRRtAGaUJAitwJsUxIXjtLrciLMkTYKVHHvcdBPWJlJbgweacXyCUdrJLDivIHXAUwSuXFCcwQLkEcIMXeLEJBPLDYylUDEaiNAWMyoheSrJjIaJaZpSdTbEXbrnbnZjtXBdHhFQXAQlnkFeENhEmtfdcPtSRpQZyAmQZPbvBoaxTbnuONpkyDxDVZTbjpwgffvUAoEdQJPFVitbXZYOxJURJKvYuuKlPgDYDMlDTBLTbUruvhctcnHhdnCRaOcZXslecSUMyLBLOWbaKRLWgHpfpUEPUSRigItYMcFocmnMsfWYNJjsKhLdspETkwqEfDACwQKGnOOjMNAuTNxWwqxiWbuvKZwTXtbLDZVqrkfjGgcClypFrPJJAbfseJlhpUrDfiZYsqbetghRHuYHfGjayxOXIwGFMmogoEuwqUXkQCBLrhLCXbyWZlHrQdxckVvGnbGUMJSIwwnDakJrBdrqfcMfwdrUkLWMGMWUpUKIxlIvLYCiphWQcHbEskTjCPZUpBSlhagcyGYnDCrlGkmoNCEvffhGmsUtuxmFaESnPMHqquXBeRraplKjxvACQQxkiSVwfBAygAFBiInlGpPlLXIEJrPJhSZwbrfXupFOrHXKZMmYAQnICrPjRmmuBsRTJOZkYZjwtBMVnomlfyTuqUnMOZUhqWverSBPanaEAxKPstliqdFBEhmJoMlQexotVFBSSwNCqHgYqalVgJeunJkqCdaoLwlBTKBaarlhFILEglvODHncMlKjdWHbeFjeLXLyXvNaqDmlDDmrmPMbtIehcSLPhkOXOGxyxOGCwgkNyBkBlBRxBWkFPbYqrLHUmWxOoyJiWCbYYBQDgGegONqvmxoCrtGxvTlJOPlSsujwvkiAResEparXIZCBlcpicxmZgIOeGsSkuqFCDMSpCfCFssJQhCoTqRbOkffkZnRNnZWNSFMUsZoErZrSLFFYjticbHyDbxmCmQqBCITatoTXdmVnEiYwwqfnJNwHHrHaAubyeweCmKHeuYCpexLUkZvMGnyylUsDCLwFNLPaAsNUmkgwddoTXieyfmBRoxnUuEWQKpYkhPUNPPFjttXuMuTiRyQYFsXAbJnjsPOHUQNDnfZpeknDMGkESVHldSPPMcwVsDFLysewPKEjZOSXDHdNaANaylGGwKRSrawtSqJNnduocuuddWiyKDbAfdKeYTTJLXPcAOfKTKlWWBeZcTnuKcJOuPRglQpYvfNdUgsWCJLjraUwBLZpSJDXeTuLmNacbHGeAAXUbrARbbGJGALrmsXAiYkGCTkTrLSCxKmyPXIUntyisXyBtMYjysxaYhMCjWrfwUlYQqxfGQFpxZZYVobhORvBeVWHRnZPgkpstxILOlKBloXOEcKUpGWCPQdtetuXMFwhmBbsNWWqkestWhrkvnttaBGbQUPvyvZFTdYYJYvULQtxwOZjTdtqGjBRiasrpiNACvngBLALWlceIVcgOfcWUmYMDZeVLKJBEqGQYTUNjXiNQjmqNePKVvLqfFBJHVW`
  * Evidence: `Connection: close`
  * Other Info: `Potential Buffer Overflow. The script closed the connection and threw a 500 Internal Server Error.`


Instances: 10

### Solution

Rewrite the background program using proper return length checking. This will require a recompile of the background executable.

### Reference


* [ https://owasp.org/www-community/attacks/Buffer_overflow_attack ](https://owasp.org/www-community/attacks/Buffer_overflow_attack)


#### CWE Id: [ 120 ](https://cwe.mitre.org/data/definitions/120.html)


#### WASC Id: 7

#### Source ID: 1

### [ Bypassing 403 ](https://www.zaproxy.org/docs/alerts/40038/)



##### Medium (Medium)

### Description

Bypassing 403 endpoints may be possible, the scan rule sent a payload that caused the response to be accessible (status code 200).

* URL: http://badstore/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: ``
  * Attack: `x-original-url: /DoingBusiness`
  * Evidence: ``
  * Other Info: `http://badstore/DoingBusiness`
* URL: http://badstore/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: ``
  * Attack: `x-original-url: /css`
  * Evidence: ``
  * Other Info: `http://badstore/css`
* URL: http://badstore/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: ``
  * Attack: `x-original-url: /images`
  * Evidence: ``
  * Other Info: `http://badstore/images`
* URL: http://badstore/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: ``
  * Attack: `x-original-url: /scanbot`
  * Evidence: ``
  * Other Info: `http://badstore/scanbot`
* URL: http://badstore/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: ``
  * Attack: `x-original-url: /scanbot/`
  * Evidence: ``
  * Other Info: `http://badstore/scanbot/`
* URL: http://badstore/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: ``
  * Attack: `x-original-url: /supplier`
  * Evidence: ``
  * Other Info: `http://badstore/supplier`
* URL: http://badstore/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: ``
  * Attack: `x-original-url: /supplier/`
  * Evidence: ``
  * Other Info: `http://badstore/supplier/`


Instances: 7

### Solution



### Reference


* [ https://www.acunetix.com/blog/articles/a-fresh-look-on-reverse-proxy-related-attacks/ ](https://www.acunetix.com/blog/articles/a-fresh-look-on-reverse-proxy-related-attacks/)
* [ https://i.blackhat.com/us-18/Wed-August-8/us-18-Orange-Tsai-Breaking-Parser-Logic-Take-Your-Path-Normalization-Off-And-Pop-0days-Out-2.pdf ](https://i.blackhat.com/us-18/Wed-August-8/us-18-Orange-Tsai-Breaking-Parser-Logic-Take-Your-Path-Normalization-Off-And-Pop-0days-Out-2.pdf)
* [ https://seclists.org/fulldisclosure/2011/Oct/273 ](https://seclists.org/fulldisclosure/2011/Oct/273)


#### CWE Id: [ 348 ](https://cwe.mitre.org/data/definitions/348.html)


#### Source ID: 1

### [ Content Security Policy (CSP) Header Not Set ](https://www.zaproxy.org/docs/alerts/10038/)



##### Medium (High)

### Description

Content Security Policy (CSP) is an added layer of security that helps to detect and mitigate certain types of attacks, including Cross Site Scripting (XSS) and data injection attacks. These attacks are used for everything from data theft to site defacement or distribution of malware. CSP provides a set of standard HTTP headers that allow website owners to declare approved sources of content that browsers should be allowed to load on that page — covered types are JavaScript, CSS, HTML frames, fonts, images and embeddable objects such as Java applets, ActiveX, audio and video files.

* URL: http://badstore:80
  * Node Name: `http://badstore`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore:80/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/cgi-bin
  * Node Name: `http://badstore/cgi-bin`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/sitemap.xml
  * Node Name: `http://badstore/sitemap.xml`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/upload
  * Node Name: `http://badstore/upload`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``

Instances: Systemic


### Solution

Ensure that your web server, application server, load balancer, etc. is configured to set the Content-Security-Policy header.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CSP ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CSP)
* [ https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html)
* [ https://www.w3.org/TR/CSP/ ](https://www.w3.org/TR/CSP/)
* [ https://w3c.github.io/webappsec-csp/ ](https://w3c.github.io/webappsec-csp/)
* [ https://web.dev/articles/csp ](https://web.dev/articles/csp)
* [ https://caniuse.com/#feat=contentsecuritypolicy ](https://caniuse.com/#feat=contentsecuritypolicy)
* [ https://content-security-policy.com/ ](https://content-security-policy.com/)


#### CWE Id: [ 693 ](https://cwe.mitre.org/data/definitions/693.html)


#### WASC Id: 15

#### Source ID: 3

### [ Integer Overflow Error ](https://www.zaproxy.org/docs/alerts/30003/)



##### Medium (Medium)

### Description

An integer overflow condition exists when an integer used in a compiled program extends beyond the range limits and has not been properly checked from the input stream.

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=search&searchquery=ZAP
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action,searchquery)`
  * Method: `GET`
  * Parameter: `searchquery`
  * Attack: `22257877771104463461240154790868977030649142`
  * Evidence: `HTTP/1.1 500 Internal Server Error`
  * Other Info: `Potential Integer Overflow. Status code changed on the input of a long string of random integers.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=cartadd
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(Add Items to Cart,cartitem)`
  * Method: `POST`
  * Parameter: `Add Items to Cart`
  * Attack: `00049831021009692920570596476485250199907406`
  * Evidence: `HTTP/1.1 500 Internal Server Error`
  * Other Info: `Potential Integer Overflow. Status code changed on the input of a long string of random integers.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=cartadd
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(Add Items to Cart,cartitem)`
  * Method: `POST`
  * Parameter: `cartitem`
  * Attack: `00797303039771999640983513095640140050995625`
  * Evidence: `HTTP/1.1 500 Internal Server Error`
  * Other Info: `Potential Integer Overflow. Status code changed on the input of a long string of random integers.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `email`
  * Attack: `13339368243892537705444074794786913867652203`
  * Evidence: `HTTP/1.1 500 Internal Server Error`
  * Other Info: `Potential Integer Overflow. Status code changed on the input of a long string of random integers.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `fullname`
  * Attack: `85660101656489002692567057012804849344555639`
  * Evidence: `HTTP/1.1 500 Internal Server Error`
  * Other Info: `Potential Integer Overflow. Status code changed on the input of a long string of random integers.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `passwd`
  * Attack: `10043288322446521121834795001388183356289158`
  * Evidence: `HTTP/1.1 500 Internal Server Error`
  * Other Info: `Potential Integer Overflow. Status code changed on the input of a long string of random integers.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `pwdhint`
  * Attack: `48444533476025064226247011809377657217357506`
  * Evidence: `HTTP/1.1 500 Internal Server Error`
  * Other Info: `Potential Integer Overflow. Status code changed on the input of a long string of random integers.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `role`
  * Attack: `92976561478768671231273691924922711612166769`
  * Evidence: `HTTP/1.1 500 Internal Server Error`
  * Other Info: `Potential Integer Overflow. Status code changed on the input of a long string of random integers.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=login
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,passwd)`
  * Method: `POST`
  * Parameter: `email`
  * Attack: `23406087292468109894275039673132348916077169`
  * Evidence: `HTTP/1.1 500 Internal Server Error`
  * Other Info: `Potential Integer Overflow. Status code changed on the input of a long string of random integers.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=login
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,passwd)`
  * Method: `POST`
  * Parameter: `passwd`
  * Attack: `36067735631981698002873275135541095202573645`
  * Evidence: `HTTP/1.1 500 Internal Server Error`
  * Other Info: `Potential Integer Overflow. Status code changed on the input of a long string of random integers.`


Instances: 10

### Solution

In order to prevent overflows and divide by 0 (zero) errors in the application, please rewrite the backend program, checking if the values of integers being processed are within the application's allowed range. This will require a recompilation of the backend executable.

### Reference


* [ https://en.wikipedia.org/wiki/Integer_overflow ](https://en.wikipedia.org/wiki/Integer_overflow)
* [ https://cwe.mitre.org/data/definitions/190.html ](https://cwe.mitre.org/data/definitions/190.html)


#### CWE Id: [ 190 ](https://cwe.mitre.org/data/definitions/190.html)


#### WASC Id: 3

#### Source ID: 1

### [ Missing Anti-clickjacking Header ](https://www.zaproxy.org/docs/alerts/10020/)



##### Medium (Medium)

### Description

The response does not protect against 'ClickJacking' attacks. It should include either Content-Security-Policy with 'frame-ancestors' directive or X-Frame-Options.

* URL: http://badstore:80
  * Node Name: `http://badstore`
  * Method: `GET`
  * Parameter: `x-frame-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore:80/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: `x-frame-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/cgi-bin/badstore.cgi
  * Node Name: `http://badstore/cgi-bin/badstore.cgi`
  * Method: `GET`
  * Parameter: `x-frame-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=aboutus
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)`
  * Method: `GET`
  * Parameter: `x-frame-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/scanbot/scanbot.html
  * Node Name: `http://badstore/scanbot/scanbot.html`
  * Method: `GET`
  * Parameter: `x-frame-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``

Instances: Systemic


### Solution

Modern Web browsers support the Content-Security-Policy and X-Frame-Options HTTP headers. Ensure one of them is set on all web pages returned by your site/app.
If you expect the page to be framed only by pages on your server (e.g. it's part of a FRAMESET) then you'll want to use SAMEORIGIN, otherwise if you never expect the page to be framed, you should use DENY. Alternatively consider implementing Content Security Policy's "frame-ancestors" directive.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/X-Frame-Options ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/X-Frame-Options)


#### CWE Id: [ 1021 ](https://cwe.mitre.org/data/definitions/1021.html)


#### WASC Id: 15

#### Source ID: 3

### [ Relative Path Confusion ](https://www.zaproxy.org/docs/alerts/10051/)



##### Medium (Medium)

### Description

The web server is configured to serve responses to ambiguous URLs in a manner that is likely to lead to confusion about the correct "relative path" for the URL. Resources (CSS, images, etc.) are also specified in the page response using relative, rather than absolute URLs. In an attack, if the web browser parses the "cross-content" response in a permissive manner, or can be tricked into permissively parsing the "cross-content" response, using techniques such as framing, then the web browser may be fooled into interpreting HTML as CSS (or other content types), leading to an XSS vulnerability.

* URL: http://badstore/cgi-bin/badstore.cgi
  * Node Name: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7`
  * Evidence: `<a href="badstore.cgi">Welcome to Badstore.net</a>`
  * Other Info: `No <base> tag was specified in the HTML <head> tag to define the location for relative URLs.
A Content Type of "text/html" was specified. If the web browser is employing strict parsing rules, this will prevent cross-content attacks from succeeding. Quirks Mode in the web browser would disable strict parsing.
Quirks Mode is implicitly enabled via the use of an old DOCTYPE with PUBLIC id "-//W3C//DTD XHTML 1.0 Strict//EN", allowing the specified Content Type to be bypassed in some web browsers.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=cartadd
  * Node Name: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7 (action)`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7?action=cartadd`
  * Evidence: `<a href="badstore.cgi">Welcome to Badstore.net</a>`
  * Other Info: `No <base> tag was specified in the HTML <head> tag to define the location for relative URLs.
A Content Type of "text/html" was specified. If the web browser is employing strict parsing rules, this will prevent cross-content attacks from succeeding. Quirks Mode in the web browser would disable strict parsing.
Quirks Mode is implicitly enabled via the use of an old DOCTYPE with PUBLIC id "-//W3C//DTD XHTML 1.0 Strict//EN", allowing the specified Content Type to be bypassed in some web browsers.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=doguestbook
  * Node Name: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7 (action)`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7?action=doguestbook`
  * Evidence: `<a href="badstore.cgi">Welcome to Badstore.net</a>`
  * Other Info: `No <base> tag was specified in the HTML <head> tag to define the location for relative URLs.
A Content Type of "text/html" was specified. If the web browser is employing strict parsing rules, this will prevent cross-content attacks from succeeding. Quirks Mode in the web browser would disable strict parsing.
Quirks Mode is implicitly enabled via the use of an old DOCTYPE with PUBLIC id "-//W3C//DTD XHTML 1.0 Strict//EN", allowing the specified Content Type to be bypassed in some web browsers.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=supupload
  * Node Name: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7 (action)`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7?action=supupload`
  * Evidence: `<a href="badstore.cgi">Welcome to Badstore.net</a>`
  * Other Info: `No <base> tag was specified in the HTML <head> tag to define the location for relative URLs.
A Content Type of "text/html" was specified. If the web browser is employing strict parsing rules, this will prevent cross-content attacks from succeeding. Quirks Mode in the web browser would disable strict parsing.
Quirks Mode is implicitly enabled via the use of an old DOCTYPE with PUBLIC id "-//W3C//DTD XHTML 1.0 Strict//EN", allowing the specified Content Type to be bypassed in some web browsers.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=viewprevious
  * Node Name: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7 (action)`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7?action=viewprevious`
  * Evidence: `<a href="badstore.cgi">Welcome to Badstore.net</a>`
  * Other Info: `No <base> tag was specified in the HTML <head> tag to define the location for relative URLs.
A Content Type of "text/html" was specified. If the web browser is employing strict parsing rules, this will prevent cross-content attacks from succeeding. Quirks Mode in the web browser would disable strict parsing.
Quirks Mode is implicitly enabled via the use of an old DOCTYPE with PUBLIC id "-//W3C//DTD XHTML 1.0 Strict//EN", allowing the specified Content Type to be bypassed in some web browsers.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=login
  * Node Name: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7 (action)`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7?action=login`
  * Evidence: `<a href="mailto:badstore@jvh.jvh.be">badstore@jvh.jvh.be</a>`
  * Other Info: `No <base> tag was specified in the HTML <head> tag to define the location for relative URLs.
A Content Type of "text/html" was specified. If the web browser is employing strict parsing rules, this will prevent cross-content attacks from succeeding. Quirks Mode in the web browser would disable strict parsing.
Quirks Mode is implicitly enabled via the absence of a DOCTYPE, allowing the specified Content Type to be bypassed.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=moduser
  * Node Name: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7 (action)`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7?action=moduser`
  * Evidence: `<a href="mailto:badstore@jvh.jvh.be">badstore@jvh.jvh.be</a>`
  * Other Info: `No <base> tag was specified in the HTML <head> tag to define the location for relative URLs.
A Content Type of "text/html" was specified. If the web browser is employing strict parsing rules, this will prevent cross-content attacks from succeeding. Quirks Mode in the web browser would disable strict parsing.
Quirks Mode is implicitly enabled via the absence of a DOCTYPE, allowing the specified Content Type to be bypassed.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7 (action)`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7?action=register`
  * Evidence: `<a href="mailto:badstore@jvh.jvh.be">badstore@jvh.jvh.be</a>`
  * Other Info: `No <base> tag was specified in the HTML <head> tag to define the location for relative URLs.
A Content Type of "text/html" was specified. If the web browser is employing strict parsing rules, this will prevent cross-content attacks from succeeding. Quirks Mode in the web browser would disable strict parsing.
Quirks Mode is implicitly enabled via the absence of a DOCTYPE, allowing the specified Content Type to be bypassed.`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=search&searchquery=ZAP
  * Node Name: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7 (action,searchquery)`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://badstore/cgi-bin/badstore.cgi/wpuo9/ro8k7?action=search&searchquery=ZAP`
  * Evidence: `<a href="mailto:badstore@jvh.jvh.be">badstore@jvh.jvh.be</a>`
  * Other Info: `No <base> tag was specified in the HTML <head> tag to define the location for relative URLs.
A Content Type of "text/html" was specified. If the web browser is employing strict parsing rules, this will prevent cross-content attacks from succeeding. Quirks Mode in the web browser would disable strict parsing.
Quirks Mode is implicitly enabled via the absence of a DOCTYPE, allowing the specified Content Type to be bypassed.`


Instances: 9

### Solution

Web servers and frameworks should be updated to be configured to not serve responses to ambiguous URLs in such a way that the relative path of such URLs could be mis-interpreted by components on either the client side, or server side.
Within the application, the correct use of the "<base>" HTML tag in the HTTP response will unambiguously specify the base URL for all relative URLs in the document.
Use the "Content-Type" HTTP response header to make it harder for the attacker to force the web browser to mis-interpret the content type of the response.
Use the "X-Content-Type-Options: nosniff" HTTP response header to prevent the web browser from "sniffing" the content type of the response.
Use a modern DOCTYPE such as "<!doctype html>" to prevent the page from being rendered in the web browser using "Quirks Mode", since this results in the content type being ignored by the web browser.
Specify the "X-Frame-Options" HTTP response header to prevent Quirks Mode from being enabled in the web browser using framing attacks.

### Reference


* [ https://arxiv.org/abs/1811.00917 ](https://arxiv.org/abs/1811.00917)
* [ https://hsivonen.fi/doctype/ ](https://hsivonen.fi/doctype/)
* [ https://www.w3schools.com/tags/tag_base.asp ](https://www.w3schools.com/tags/tag_base.asp)


#### CWE Id: [ 20 ](https://cwe.mitre.org/data/definitions/20.html)


#### WASC Id: 20

#### Source ID: 1

### [ Source Code Disclosure - SQL ](https://www.zaproxy.org/docs/alerts/10099/)



##### Medium (Medium)

### Description

Application Source Code was disclosed by the web server. - SQL

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=search&searchquery=ZAP
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action,searchquery)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `SELECT itemnum, sdesc, ldesc, price FROM itemdb WHERE `
  * Other Info: ``


Instances: 1

### Solution

Ensure that application Source Code is not available with alternative extensions, and ensure that source code is not present within other files or data deployed to the web server, or served by the web server.

### Reference


* [ https://nhimg.org/twitter-breach ](https://nhimg.org/twitter-breach)


#### CWE Id: [ 540 ](https://cwe.mitre.org/data/definitions/540.html)


#### WASC Id: 13

#### Source ID: 3

### [ Cookie No HttpOnly Flag ](https://www.zaproxy.org/docs/alerts/10010/)



##### Low (Medium)

### Description

A cookie has been set without the HttpOnly flag, which means that the cookie can be accessed by JavaScript. If a malicious script can be run on this page then the cookie will be accessible and can be transmitted to another site. If this is a session cookie then session hijacking may be possible.

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=cartadd
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(Add Items to Cart,cartitem)`
  * Method: `POST`
  * Parameter: `CartID`
  * Attack: ``
  * Evidence: `Set-Cookie: CartID`
  * Other Info: ``
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `SSOid`
  * Attack: ``
  * Evidence: `Set-Cookie: SSOid`
  * Other Info: ``
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=login
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,passwd)`
  * Method: `POST`
  * Parameter: `SSOid`
  * Attack: ``
  * Evidence: `Set-Cookie: SSOid`
  * Other Info: ``


Instances: 3

### Solution

Ensure that the HttpOnly flag is set for all cookies.

### Reference


* [ https://owasp.org/www-community/HttpOnly ](https://owasp.org/www-community/HttpOnly)


#### CWE Id: [ 1004 ](https://cwe.mitre.org/data/definitions/1004.html)


#### WASC Id: 13

#### Source ID: 3

### [ Cookie without SameSite Attribute ](https://www.zaproxy.org/docs/alerts/10054/)



##### Low (Medium)

### Description

A cookie has been set without the SameSite attribute, which means that the cookie can be sent as a result of a 'cross-site' request. The SameSite attribute is an effective counter measure to cross-site request forgery, cross-site script inclusion, and timing attacks.

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=cartadd
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(Add Items to Cart,cartitem)`
  * Method: `POST`
  * Parameter: `CartID`
  * Attack: ``
  * Evidence: `Set-Cookie: CartID`
  * Other Info: ``
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `SSOid`
  * Attack: ``
  * Evidence: `Set-Cookie: SSOid`
  * Other Info: ``
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=login
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,passwd)`
  * Method: `POST`
  * Parameter: `SSOid`
  * Attack: ``
  * Evidence: `Set-Cookie: SSOid`
  * Other Info: ``


Instances: 3

### Solution

Ensure that the SameSite attribute is set to either 'lax' or ideally 'strict' for all cookies.

### Reference


* [ https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-cookie-same-site ](https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-cookie-same-site)


#### CWE Id: [ 1275 ](https://cwe.mitre.org/data/definitions/1275.html)


#### WASC Id: 13

#### Source ID: 3

### [ In Page Banner Information Leak ](https://www.zaproxy.org/docs/alerts/10009/)



##### Low (High)

### Description

The server returned a version banner string in the response content. Such information leaks may allow attackers to further target specific issues impacting the product and version in use.

* URL: http://badstore/cgi-bin
  * Node Name: `http://badstore/cgi-bin`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Apache/2.4.65`
  * Other Info: `There is a chance that the highlight in the finding is on a value in the headers, versus the actual matched string in the response body.`
* URL: http://badstore/scanbot/
  * Node Name: `http://badstore/scanbot/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Apache/2.4.65`
  * Other Info: `There is a chance that the highlight in the finding is on a value in the headers, versus the actual matched string in the response body.`
* URL: http://badstore/sitemap.xml
  * Node Name: `http://badstore/sitemap.xml`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Apache/2.4.65`
  * Other Info: `There is a chance that the highlight in the finding is on a value in the headers, versus the actual matched string in the response body.`
* URL: http://badstore/supplier/
  * Node Name: `http://badstore/supplier/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Apache/2.4.65`
  * Other Info: `There is a chance that the highlight in the finding is on a value in the headers, versus the actual matched string in the response body.`
* URL: http://badstore/upload
  * Node Name: `http://badstore/upload`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Apache/2.4.65`
  * Other Info: `There is a chance that the highlight in the finding is on a value in the headers, versus the actual matched string in the response body.`

Instances: Systemic


### Solution

Configure the server to prevent such information leaks. For example:
Under Tomcat this is done via the "server" directive and implementation of custom error pages.
Under Apache this is done via the "ServerSignature" and "ServerTokens" directives.

### Reference


* [ https://owasp.org/www-project-web-security-testing-guide/v41/4-Web_Application_Security_Testing/08-Testing_for_Error_Handling/ ](https://owasp.org/www-project-web-security-testing-guide/v41/4-Web_Application_Security_Testing/08-Testing_for_Error_Handling/)


#### CWE Id: [ 497 ](https://cwe.mitre.org/data/definitions/497.html)


#### WASC Id: 13

#### Source ID: 3

### [ Insufficient Site Isolation Against Spectre Vulnerability ](https://www.zaproxy.org/docs/alerts/90004/)



##### Low (Medium)

### Description

Cross-Origin-Resource-Policy header is an opt-in header designed to counter side-channels attacks like Spectre. Resource should be specifically set as shareable amongst different origins.

* URL: http://badstore:80
  * Node Name: `http://badstore`
  * Method: `GET`
  * Parameter: `Cross-Origin-Resource-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore:80/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: `Cross-Origin-Resource-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/backup/
  * Node Name: `http://badstore/backup/`
  * Method: `GET`
  * Parameter: `Cross-Origin-Resource-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/images/store1.jpg
  * Node Name: `http://badstore/images/store1.jpg`
  * Method: `GET`
  * Parameter: `Cross-Origin-Resource-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/robots.txt
  * Node Name: `http://badstore/robots.txt`
  * Method: `GET`
  * Parameter: `Cross-Origin-Resource-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore:80
  * Node Name: `http://badstore`
  * Method: `GET`
  * Parameter: `Cross-Origin-Embedder-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore:80/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: `Cross-Origin-Embedder-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/backup/
  * Node Name: `http://badstore/backup/`
  * Method: `GET`
  * Parameter: `Cross-Origin-Embedder-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore
  * Node Name: `http://badstore`
  * Method: `GET`
  * Parameter: `Cross-Origin-Opener-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore:80/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: `Cross-Origin-Opener-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/backup/
  * Node Name: `http://badstore/backup/`
  * Method: `GET`
  * Parameter: `Cross-Origin-Opener-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``

Instances: Systemic


### Solution

Ensure that the application/web server sets the Cross-Origin-Resource-Policy header appropriately, and that it sets the Cross-Origin-Resource-Policy header to 'same-origin' for all web pages.
'same-site' is considered as less secured and should be avoided.
If resources must be shared, set the header to 'cross-origin'.
If possible, ensure that the end user uses a standards-compliant and modern web browser that supports the Cross-Origin-Resource-Policy header (https://caniuse.com/mdn-http_headers_cross-origin-resource-policy).

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Cross-Origin-Embedder-Policy ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Cross-Origin-Embedder-Policy)


#### CWE Id: [ 693 ](https://cwe.mitre.org/data/definitions/693.html)


#### WASC Id: 14

#### Source ID: 3

### [ Permissions Policy Header Not Set ](https://www.zaproxy.org/docs/alerts/10063/)



##### Low (Medium)

### Description

Permissions Policy Header is an added layer of security that helps to restrict from unauthorized access or usage of browser/client features by web resources. This policy ensures the user privacy by limiting or specifying the features of the browsers can be used by the web resources. Permissions Policy provides a set of standard HTTP headers that allow website owners to limit which features of browsers can be used by the page such as camera, microphone, location, full screen etc.

* URL: http://badstore:80
  * Node Name: `http://badstore`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore:80/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/cgi-bin
  * Node Name: `http://badstore/cgi-bin`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/sitemap.xml
  * Node Name: `http://badstore/sitemap.xml`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/upload
  * Node Name: `http://badstore/upload`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``

Instances: Systemic


### Solution

Ensure that your web server, application server, load balancer, etc. is configured to set the Permissions-Policy header.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Permissions-Policy ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Permissions-Policy)
* [ https://developer.chrome.com/blog/feature-policy/ ](https://developer.chrome.com/blog/feature-policy/)
* [ https://scotthelme.co.uk/a-new-security-header-feature-policy/ ](https://scotthelme.co.uk/a-new-security-header-feature-policy/)
* [ https://w3c.github.io/webappsec-feature-policy/ ](https://w3c.github.io/webappsec-feature-policy/)
* [ https://www.smashingmagazine.com/2018/12/feature-policy/ ](https://www.smashingmagazine.com/2018/12/feature-policy/)


#### CWE Id: [ 693 ](https://cwe.mitre.org/data/definitions/693.html)


#### WASC Id: 15

#### Source ID: 3

### [ Private IP Disclosure ](https://www.zaproxy.org/docs/alerts/2/)



##### Low (Medium)

### Description

A private IP (such as 10.x.x.x, 172.x.x.x, 192.168.x.x) or an Amazon EC2 private hostname (for example, ip-10-0-56-78) has been found in the HTTP response body. This information might be helpful for further attacks targeting internal systems.

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=doguestbook
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(comments,email,name)`
  * Method: `POST`
  * Parameter: ``
  * Attack: ``
  * Evidence: `10.0.0.1`
  * Other Info: `10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
10.0.0.1
10.0.0.2
10.0.0.3
10.0.0.4
10.0.0.5
`


Instances: 1

### Solution

Remove the private IP address from the HTTP response body. For comments, use JSP/ASP/PHP comment instead of HTML/JavaScript comment which can be seen by client browsers.

### Reference


* [ https://datatracker.ietf.org/doc/html/rfc1918 ](https://datatracker.ietf.org/doc/html/rfc1918)


#### CWE Id: [ 497 ](https://cwe.mitre.org/data/definitions/497.html)


#### WASC Id: 13

#### Source ID: 3

### [ Server Leaks Version Information via "Server" HTTP Response Header Field ](https://www.zaproxy.org/docs/alerts/10036/)



##### Low (High)

### Description

The web/application server is leaking version information via the "Server" HTTP response header. Access to such information may facilitate attackers identifying other vulnerabilities your web/application server is subject to.

* URL: http://badstore:80
  * Node Name: `http://badstore`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Apache/2.4.65 (Debian)`
  * Other Info: ``
* URL: http://badstore:80/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Apache/2.4.65 (Debian)`
  * Other Info: ``
* URL: http://badstore/backup
  * Node Name: `http://badstore/backup`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Apache/2.4.65 (Debian)`
  * Other Info: ``
* URL: http://badstore/robots.txt
  * Node Name: `http://badstore/robots.txt`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Apache/2.4.65 (Debian)`
  * Other Info: ``
* URL: http://badstore/sitemap.xml
  * Node Name: `http://badstore/sitemap.xml`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Apache/2.4.65 (Debian)`
  * Other Info: ``

Instances: Systemic


### Solution

Ensure that your web server, application server, load balancer, etc. is configured to suppress the "Server" header or provide generic details.

### Reference


* [ https://httpd.apache.org/docs/current/mod/core.html#servertokens ](https://httpd.apache.org/docs/current/mod/core.html#servertokens)
* [ https://learn.microsoft.com/en-us/previous-versions/msp-n-p/ff648552(v=pandp.10) ](https://learn.microsoft.com/en-us/previous-versions/msp-n-p/ff648552(v=pandp.10))
* [ https://www.troyhunt.com/shhh-dont-let-your-response-headers/ ](https://www.troyhunt.com/shhh-dont-let-your-response-headers/)


#### CWE Id: [ 497 ](https://cwe.mitre.org/data/definitions/497.html)


#### WASC Id: 13

#### Source ID: 3

### [ X-Content-Type-Options Header Missing ](https://www.zaproxy.org/docs/alerts/10021/)



##### Low (Medium)

### Description

The Anti-MIME-Sniffing header X-Content-Type-Options was not set to 'nosniff'. This allows older versions of Internet Explorer and Chrome to perform MIME-sniffing on the response body, potentially causing the response body to be interpreted and displayed as a content type other than the declared content type. Current (early 2014) and legacy versions of Firefox will use the declared content type (if one is set), rather than performing MIME-sniffing.

* URL: http://badstore:80
  * Node Name: `http://badstore`
  * Method: `GET`
  * Parameter: `x-content-type-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: `This issue still applies to error type pages (401, 403, 500, etc.) as those pages are often still affected by injection issues, in which case there is still concern for browsers sniffing pages away from their actual content type.
At "High" threshold this scan rule will not alert on client or server error responses.`
* URL: http://badstore:80/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: `x-content-type-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: `This issue still applies to error type pages (401, 403, 500, etc.) as those pages are often still affected by injection issues, in which case there is still concern for browsers sniffing pages away from their actual content type.
At "High" threshold this scan rule will not alert on client or server error responses.`
* URL: http://badstore/DoingBusiness/contract.doc
  * Node Name: `http://badstore/DoingBusiness/contract.doc`
  * Method: `GET`
  * Parameter: `x-content-type-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: `This issue still applies to error type pages (401, 403, 500, etc.) as those pages are often still affected by injection issues, in which case there is still concern for browsers sniffing pages away from their actual content type.
At "High" threshold this scan rule will not alert on client or server error responses.`
* URL: http://badstore/css/global.css
  * Node Name: `http://badstore/css/global.css`
  * Method: `GET`
  * Parameter: `x-content-type-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: `This issue still applies to error type pages (401, 403, 500, etc.) as those pages are often still affected by injection issues, in which case there is still concern for browsers sniffing pages away from their actual content type.
At "High" threshold this scan rule will not alert on client or server error responses.`
* URL: http://badstore/robots.txt
  * Node Name: `http://badstore/robots.txt`
  * Method: `GET`
  * Parameter: `x-content-type-options`
  * Attack: ``
  * Evidence: ``
  * Other Info: `This issue still applies to error type pages (401, 403, 500, etc.) as those pages are often still affected by injection issues, in which case there is still concern for browsers sniffing pages away from their actual content type.
At "High" threshold this scan rule will not alert on client or server error responses.`

Instances: Systemic


### Solution

Ensure that the application/web server sets the Content-Type header appropriately, and that it sets the X-Content-Type-Options header to 'nosniff' for all web pages.
If possible, ensure that the end user uses a standards-compliant and modern web browser that does not perform MIME-sniffing at all, or that can be directed by the web application/web server to not perform MIME-sniffing.

### Reference


* [ https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/compatibility/gg622941(v=vs.85) ](https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/compatibility/gg622941(v=vs.85))
* [ https://owasp.org/www-community/Security_Headers ](https://owasp.org/www-community/Security_Headers)


#### CWE Id: [ 693 ](https://cwe.mitre.org/data/definitions/693.html)


#### WASC Id: 15

#### Source ID: 3

### [ Authentication Request Identified ](https://www.zaproxy.org/docs/alerts/10111/)



##### Informational (Low)

### Description

The given request has been identified as an authentication request. The 'Other Info' field contains a set of key=value lines which identify any relevant fields. If the request is in a context which has an Authentication Method set to "Auto-Detect" then this rule will change the authentication to match the request identified.

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=moduser
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(DoMods,email,pwdhint)`
  * Method: `POST`
  * Parameter: `email`
  * Attack: ``
  * Evidence: `pwdhint`
  * Other Info: `userParam=email
userValue=zaproxy@example.com
passwordParam=pwdhint
referer=http://badstore/cgi-bin/badstore.cgi?action=myaccount`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=supplierportal
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,passwd)`
  * Method: `POST`
  * Parameter: `email`
  * Attack: ``
  * Evidence: `passwd`
  * Other Info: `userParam=email
userValue=zaproxy@example.com
passwordParam=passwd
referer=http://badstore/cgi-bin/badstore.cgi?action=supplierlogin`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=login
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,passwd)`
  * Method: `POST`
  * Parameter: `email`
  * Attack: ``
  * Evidence: `passwd`
  * Other Info: `userParam=email
userValue=zaproxy@example.com
passwordParam=passwd
referer=http://badstore/cgi-bin/badstore.cgi?action=loginregister`


Instances: 3

### Solution

This is an informational alert rather than a vulnerability and so there is nothing to fix.

### Reference


* [ https://www.zaproxy.org/docs/desktop/addons/authentication-helper/auth-req-id/ ](https://www.zaproxy.org/docs/desktop/addons/authentication-helper/auth-req-id/)



#### Source ID: 3

### [ Base64 Disclosure ](https://www.zaproxy.org/docs/alerts/10094/)



##### Informational (Medium)

### Description

Base64 encoded data was disclosed by the application/web server. Note: in the interests of performance not all base64 strings in the response were analyzed individually, the entire response should be looked at by the analyst/security team/developer(s).

* URL: http://badstore/BadStore_net_v1_2_Manual.pdf
  * Node Name: `http://badstore/BadStore_net_v1_2_Manual.pdf`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `169/Subtype/TrueType/FontDescriptor`
  * Other Info: `ׯJ��ʗ�N��O*^�Z'�7�r����`
* URL: http://badstore/cgi-bin/badstore.cgi
  * Node Name: `http://badstore/cgi-bin/badstore.cgi`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `org/TR/xhtml1/DTD/xhtml1-strict`
  * Other Info: `��?M�٥����a�iu��k��`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=aboutus
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `org/TR/xhtml1/DTD/xhtml1-strict`
  * Other Info: `��?M�٥����a�iu��k��`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=search&searchquery=ZAP
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action,searchquery)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `org/TR/xhtml1/DTD/xhtml1-strict`
  * Other Info: `��?M�٥����a�iu��k��`
* URL: http://badstore/cgi-bin/bsheader.cgi
  * Node Name: `http://badstore/cgi-bin/bsheader.cgi`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `org/TR/xhtml1/DTD/xhtml1-strict`
  * Other Info: `��?M�٥����a�iu��k��`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=moduser
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(DoMods,email,pwdhint)`
  * Method: `POST`
  * Parameter: ``
  * Attack: ``
  * Evidence: `org/TR/xhtml1/DTD/xhtml1-strict`
  * Other Info: `��?M�٥����a�iu��k��`


Instances: 6

### Solution

Manually confirm that the Base64 data does not leak sensitive information, and that the data cannot be aggregated/used to exploit other vulnerabilities.

### Reference


* [ https://projects.webappsec.org/w/page/13246936/Information%20Leakage ](https://projects.webappsec.org/w/page/13246936/Information%20Leakage)


#### CWE Id: [ 319 ](https://cwe.mitre.org/data/definitions/319.html)


#### WASC Id: 13

#### Source ID: 3

### [ Cookie Slack Detector ](https://www.zaproxy.org/docs/alerts/90027/)



##### Informational (Low)

### Description

Repeated GET requests: drop a different cookie each time, followed by normal request with all cookies to stabilize session, compare responses against original baseline GET. This can reveal areas where cookie based authentication/attributes are not actually enforced.

* URL: http://badstore/cgi-bin/x
  * Node Name: `http://badstore/cgi-bin/x`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: `Cookies that don't have expected effects can reveal flaws in application logic. In the worst case, this can reveal where authentication via cookie token(s) is not actually enforced.
These cookies affected the response: 
These cookies did NOT affect the response: SSOid,CartID
`
* URL: http://badstore/images/1000.jpg
  * Node Name: `http://badstore/images/1000.jpg`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: `Cookies that don't have expected effects can reveal flaws in application logic. In the worst case, this can reveal where authentication via cookie token(s) is not actually enforced.
These cookies affected the response: 
These cookies did NOT affect the response: SSOid
`
* URL: http://badstore/images/1003.jpg
  * Node Name: `http://badstore/images/1003.jpg`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: `Cookies that don't have expected effects can reveal flaws in application logic. In the worst case, this can reveal where authentication via cookie token(s) is not actually enforced.
These cookies affected the response: 
These cookies did NOT affect the response: SSOid
`
* URL: http://badstore/images/1005.jpg
  * Node Name: `http://badstore/images/1005.jpg`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: `Cookies that don't have expected effects can reveal flaws in application logic. In the worst case, this can reveal where authentication via cookie token(s) is not actually enforced.
These cookies affected the response: 
These cookies did NOT affect the response: SSOid
`
* URL: http://badstore/images/1011.jpg
  * Node Name: `http://badstore/images/1011.jpg`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: `Cookies that don't have expected effects can reveal flaws in application logic. In the worst case, this can reveal where authentication via cookie token(s) is not actually enforced.
These cookies affected the response: 
These cookies did NOT affect the response: SSOid
`

Instances: Systemic


### Solution



### Reference


* [ https://cwe.mitre.org/data/definitions/205.html ](https://cwe.mitre.org/data/definitions/205.html)


#### CWE Id: [ 205 ](https://cwe.mitre.org/data/definitions/205.html)


#### WASC Id: 45

#### Source ID: 1

### [ GET for POST ](https://www.zaproxy.org/docs/alerts/10058/)



##### Informational (High)

### Description

A request that was originally observed as a POST was also accepted as a GET. This issue does not represent a security weakness unto itself, however, it may facilitate simplification of other attacks. For example if the original POST is subject to Cross-Site Scripting (XSS), then this finding may indicate that a simplified (GET based) XSS may also be possible.

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=cartadd
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (Add Items to Cart,cartitem)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `GET http://badstore/cgi-bin/badstore.cgi?Add%20Items%20to%20Cart=Add%20Items%20to%20Cart&cartitem=1000 HTTP/1.1`
  * Other Info: ``
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=moduser
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (DoMods,email,pwdhint)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `GET http://badstore/cgi-bin/badstore.cgi?DoMods=Reset%20User%20Password&email=zaproxy@example.com&pwdhint=blue HTTP/1.1`
  * Other Info: ``
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (email,fullname,passwd,pwdhint,role)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `GET http://badstore/cgi-bin/badstore.cgi?email=zaproxy@example.com&fullname=ZAP&passwd=ZAP&pwdhint=blue&role=U HTTP/1.1`
  * Other Info: ``
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=login
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (email,passwd)`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `GET http://badstore/cgi-bin/badstore.cgi?email=zaproxy@example.com&passwd=ZAP HTTP/1.1`
  * Other Info: ``


Instances: 4

### Solution

Ensure that only POST is accepted where POST is expected.

### Reference



#### CWE Id: [ 16 ](https://cwe.mitre.org/data/definitions/16.html)


#### WASC Id: 20

#### Source ID: 1

### [ Information Disclosure - Suspicious Comments ](https://www.zaproxy.org/docs/alerts/10027/)



##### Informational (Medium)

### Description

The response appears to contain suspicious comments which may help an attacker.

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=doguestbook
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(comments,email,name)`
  * Method: `POST`
  * Parameter: ``
  * Attack: ``
  * Evidence: `select`
  * Other Info: `The following pattern was used: \bSELECT\b and was detected 4 times, the first in likely comment: "<!--</A>
<OL><I>
</I></OL>
<HR>
Wednesday, February 11, 2026 at 17:53:54: <B>ZAP</B> <A HREF=mailto:]]>>]]></A>
<OL><I>
</I></OL", see evidence field for the suspicious comment/snippet.`


Instances: 1

### Solution

Remove all comments that return information that may help an attacker and fix any underlying problems they refer to.

### Reference



#### CWE Id: [ 615 ](https://cwe.mitre.org/data/definitions/615.html)


#### WASC Id: 13

#### Source ID: 3

### [ Modern Web Application ](https://www.zaproxy.org/docs/alerts/10109/)



##### Informational (Medium)

### Description

The application appears to be a modern web application. If you need to explore it automatically then the Ajax Spider may well be more effective than the standard one.

* URL: http://badstore/scanbot/scanbot.html
  * Node Name: `http://badstore/scanbot/scanbot.html`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<SCRIPT language="javascript">
<!-- Begin
function redirect() {
var destination = 'http://www.badstore.net/scanbot/deth2botz.html';
window.location = destination;
}
redirect();
// End -->
</SCRIPT>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`


Instances: 1

### Solution

This is an informational alert and so no changes are required.

### Reference




#### Source ID: 3

### [ Non-Storable Content ](https://www.zaproxy.org/docs/alerts/10049/)



##### Informational (Medium)

### Description

The response contents are not storable by caching components such as proxy servers. If the response does not contain sensitive, personal or user-specific information, it may benefit from being stored and cached, to improve performance.

* URL: http://badstore/scanbot/
  * Node Name: `http://badstore/scanbot/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `403`
  * Other Info: ``
* URL: http://badstore/supplier/
  * Node Name: `http://badstore/supplier/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `403`
  * Other Info: ``


Instances: 2

### Solution

The content may be marked as storable by ensuring that the following conditions are satisfied:
The request method must be understood by the cache and defined as being cacheable ("GET", "HEAD", and "POST" are currently defined as cacheable)
The response status code must be understood by the cache (one of the 1XX, 2XX, 3XX, 4XX, or 5XX response classes are generally understood)
The "no-store" cache directive must not appear in the request or response header fields
For caching by "shared" caches such as "proxy" caches, the "private" response directive must not appear in the response
For caching by "shared" caches such as "proxy" caches, the "Authorization" header field must not appear in the request, unless the response explicitly allows it (using one of the "must-revalidate", "public", or "s-maxage" Cache-Control response directives)
In addition to the conditions above, at least one of the following conditions must also be satisfied by the response:
It must contain an "Expires" header field
It must contain a "max-age" response directive
For "shared" caches such as "proxy" caches, it must contain a "s-maxage" response directive
It must contain a "Cache Control Extension" that allows it to be cached
It must have a status code that is defined as cacheable by default (200, 203, 204, 206, 300, 301, 404, 405, 410, 414, 501).

### Reference


* [ https://datatracker.ietf.org/doc/html/rfc7234 ](https://datatracker.ietf.org/doc/html/rfc7234)
* [ https://datatracker.ietf.org/doc/html/rfc7231 ](https://datatracker.ietf.org/doc/html/rfc7231)
* [ https://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html ](https://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html)


#### CWE Id: [ 524 ](https://cwe.mitre.org/data/definitions/524.html)


#### WASC Id: 13

#### Source ID: 3

### [ Sec-Fetch-Dest Header is Missing ](https://www.zaproxy.org/docs/alerts/90005/)



##### Informational (High)

### Description

Specifies how and where the data would be used. For instance, if the value is audio, then the requested resource must be audio data and not any other type of resource.

* URL: http://badstore:80/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Dest`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/scanbot
  * Node Name: `http://badstore/scanbot`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Dest`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/sitemap.xml
  * Node Name: `http://badstore/sitemap.xml`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Dest`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/supplier
  * Node Name: `http://badstore/supplier`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Dest`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``


Instances: 4

### Solution

Ensure that Sec-Fetch-Dest header is included in request headers.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-Fetch-Dest ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-Fetch-Dest)


#### CWE Id: [ 352 ](https://cwe.mitre.org/data/definitions/352.html)


#### WASC Id: 9

#### Source ID: 3

### [ Sec-Fetch-Mode Header is Missing ](https://www.zaproxy.org/docs/alerts/90005/)



##### Informational (High)

### Description

Allows to differentiate between requests for navigating between HTML pages and requests for loading resources like images, audio etc.

* URL: http://badstore:80/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Mode`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/scanbot
  * Node Name: `http://badstore/scanbot`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Mode`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/sitemap.xml
  * Node Name: `http://badstore/sitemap.xml`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Mode`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/supplier
  * Node Name: `http://badstore/supplier`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Mode`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``


Instances: 4

### Solution

Ensure that Sec-Fetch-Mode header is included in request headers.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-Fetch-Mode ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-Fetch-Mode)


#### CWE Id: [ 352 ](https://cwe.mitre.org/data/definitions/352.html)


#### WASC Id: 9

#### Source ID: 3

### [ Sec-Fetch-Site Header is Missing ](https://www.zaproxy.org/docs/alerts/90005/)



##### Informational (High)

### Description

Specifies the relationship between request initiator's origin and target's origin.

* URL: http://badstore:80/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Site`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/scanbot
  * Node Name: `http://badstore/scanbot`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Site`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/sitemap.xml
  * Node Name: `http://badstore/sitemap.xml`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Site`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/supplier
  * Node Name: `http://badstore/supplier`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Site`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``


Instances: 4

### Solution

Ensure that Sec-Fetch-Site header is included in request headers.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-Fetch-Site ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-Fetch-Site)


#### CWE Id: [ 352 ](https://cwe.mitre.org/data/definitions/352.html)


#### WASC Id: 9

#### Source ID: 3

### [ Sec-Fetch-User Header is Missing ](https://www.zaproxy.org/docs/alerts/90005/)



##### Informational (High)

### Description

Specifies if a navigation request was initiated by a user.

* URL: http://badstore:80/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: `Sec-Fetch-User`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/scanbot
  * Node Name: `http://badstore/scanbot`
  * Method: `GET`
  * Parameter: `Sec-Fetch-User`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/sitemap.xml
  * Node Name: `http://badstore/sitemap.xml`
  * Method: `GET`
  * Parameter: `Sec-Fetch-User`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/supplier
  * Node Name: `http://badstore/supplier`
  * Method: `GET`
  * Parameter: `Sec-Fetch-User`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``


Instances: 4

### Solution

Ensure that Sec-Fetch-User header is included in user initiated requests.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-Fetch-User ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-Fetch-User)


#### CWE Id: [ 352 ](https://cwe.mitre.org/data/definitions/352.html)


#### WASC Id: 9

#### Source ID: 3

### [ Session Management Response Identified ](https://www.zaproxy.org/docs/alerts/10112/)



##### Informational (Medium)

### Description

The given response has been identified as containing a session management token. The 'Other Info' field contains a set of header tokens that can be used in the Header Based Session Management Method. If the request is in a context which has a Session Management Method set to "Auto-Detect" then this rule will change the session management to use the tokens identified.

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=cartadd
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(Add Items to Cart,cartitem)`
  * Method: `POST`
  * Parameter: `CartID`
  * Attack: ``
  * Evidence: `CartID`
  * Other Info: `cookie:CartID`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=register
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,fullname,passwd,pwdhint,role)`
  * Method: `POST`
  * Parameter: `SSOid`
  * Attack: ``
  * Evidence: `SSOid`
  * Other Info: `cookie:SSOid`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=login
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(email,passwd)`
  * Method: `POST`
  * Parameter: `SSOid`
  * Attack: ``
  * Evidence: `SSOid`
  * Other Info: `cookie:SSOid`
* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=cartadd
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action)(Add Items to Cart,cartitem)`
  * Method: `POST`
  * Parameter: `CartID`
  * Attack: ``
  * Evidence: `CartID`
  * Other Info: `cookie:CartID`


Instances: 4

### Solution

This is an informational alert rather than a vulnerability and so there is nothing to fix.

### Reference


* [ https://www.zaproxy.org/docs/desktop/addons/authentication-helper/session-mgmt-id/ ](https://www.zaproxy.org/docs/desktop/addons/authentication-helper/session-mgmt-id/)



#### Source ID: 3

### [ Storable and Cacheable Content ](https://www.zaproxy.org/docs/alerts/10049/)



##### Informational (Medium)

### Description

The response contents are storable by caching components such as proxy servers, and may be retrieved directly from the cache, rather than from the origin server by the caching servers, in response to similar requests from other users. If the response data is sensitive, personal or user-specific, this may result in sensitive information being leaked. In some cases, this may even result in a user gaining complete control of the session of another user, depending on the configuration of the caching components in use in their environment. This is primarily an issue where "shared" caching servers such as "proxy" caches are configured on the local network. This configuration is typically found in corporate or educational environments, for instance.

* URL: http://badstore:80
  * Node Name: `http://badstore`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: `In the absence of an explicitly specified caching lifetime directive in the response, a liberal lifetime heuristic of 1 year was assumed. This is permitted by rfc7234.`
* URL: http://badstore:80/
  * Node Name: `http://badstore/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: `In the absence of an explicitly specified caching lifetime directive in the response, a liberal lifetime heuristic of 1 year was assumed. This is permitted by rfc7234.`
* URL: http://badstore/robots.txt
  * Node Name: `http://badstore/robots.txt`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: `In the absence of an explicitly specified caching lifetime directive in the response, a liberal lifetime heuristic of 1 year was assumed. This is permitted by rfc7234.`
* URL: http://badstore/scanbot
  * Node Name: `http://badstore/scanbot`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: `In the absence of an explicitly specified caching lifetime directive in the response, a liberal lifetime heuristic of 1 year was assumed. This is permitted by rfc7234.`
* URL: http://badstore/sitemap.xml
  * Node Name: `http://badstore/sitemap.xml`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: `In the absence of an explicitly specified caching lifetime directive in the response, a liberal lifetime heuristic of 1 year was assumed. This is permitted by rfc7234.`

Instances: Systemic


### Solution

Validate that the response does not contain sensitive, personal or user-specific information. If it does, consider the use of the following HTTP response headers, to limit, or prevent the content being stored and retrieved from the cache by another user:
Cache-Control: no-cache, no-store, must-revalidate, private
Pragma: no-cache
Expires: 0
This configuration directs both HTTP 1.0 and HTTP 1.1 compliant caching servers to not store the response, and to not retrieve the response (without validation) from the cache, in response to a similar request.

### Reference


* [ https://datatracker.ietf.org/doc/html/rfc7234 ](https://datatracker.ietf.org/doc/html/rfc7234)
* [ https://datatracker.ietf.org/doc/html/rfc7231 ](https://datatracker.ietf.org/doc/html/rfc7231)
* [ https://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html ](https://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html)


#### CWE Id: [ 524 ](https://cwe.mitre.org/data/definitions/524.html)


#### WASC Id: 13

#### Source ID: 3

### [ User Agent Fuzzer ](https://www.zaproxy.org/docs/alerts/10104/)



##### Informational (Medium)

### Description

Check for differences in response based on fuzzed User Agent (eg. mobile sites, access as a Search Engine Crawler). Compares the response statuscode and the hashcode of the response body with the original response.

* URL: http://badstore/DoingBusiness
  * Node Name: `http://badstore/DoingBusiness`
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)`
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/DoingBusiness
  * Node Name: `http://badstore/DoingBusiness`
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1)`
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/backup
  * Node Name: `http://badstore/backup`
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)`
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/backup
  * Node Name: `http://badstore/backup`
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)`
  * Evidence: ``
  * Other Info: ``
* URL: http://badstore/backup
  * Node Name: `http://badstore/backup`
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1)`
  * Evidence: ``
  * Other Info: ``

Instances: Systemic


### Solution



### Reference


* [ https://owasp.org/wstg ](https://owasp.org/wstg)



#### Source ID: 1

### [ User Controllable HTML Element Attribute (Potential XSS) ](https://www.zaproxy.org/docs/alerts/10031/)



##### Informational (Low)

### Description

This check looks at user-supplied input in query string parameters and POST data to identify where certain HTML attribute values might be controlled. This provides hot-spot detection for XSS (cross-site scripting) that will require further review by a security analyst to determine exploitability.

* URL: http://badstore/cgi-bin/badstore.cgi%3Faction=search&searchquery=ZAP
  * Node Name: `http://badstore/cgi-bin/badstore.cgi (action,searchquery)`
  * Method: `GET`
  * Parameter: `action`
  * Attack: ``
  * Evidence: ``
  * Other Info: `User-controlled HTML attribute values were found. Try injecting special characters to see if XSS might be possible. The page at the following URL:

http://badstore/cgi-bin/badstore.cgi?action=search&searchquery=ZAP

appears to include user input in:
a(n) [input] tag [value] attribute

The user input found was:
action=search

The user-controlled value was:
search`


Instances: 1

### Solution

Validate all input and sanitize output it before writing to any HTML attributes.

### Reference


* [ https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html)


#### CWE Id: [ 20 ](https://cwe.mitre.org/data/definitions/20.html)


#### WASC Id: 20

#### Source ID: 3


