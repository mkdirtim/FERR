# ZAP Report

ZAP by [Checkmarx](https://checkmarx.com/).


## Summary of Alerts

| Risk Level | Number of Alerts |
| --- | --- |
| High | 0 |
| Medium | 3 |
| Low | 2 |
| Informational | 3 |




## Alerts

| Name | Risk Level | Number of Instances |
| --- | --- | --- |
| Content Security Policy (CSP) Header Not Set | Medium | 58 |
| Cross-Domain Misconfiguration | Medium | 69 |
| Hidden File Found | Medium | 4 |
| Cross-Domain JavaScript Source File Inclusion | Low | 98 |
| Timestamp Disclosure - Unix | Low | 158 |
| Information Disclosure - Suspicious Comments | Informational | 2 |
| Modern Web Application | Informational | 50 |
| User Agent Fuzzer | Informational | 24 |




## Alert Detail



### [ Content Security Policy (CSP) Header Not Set ](https://www.zaproxy.org/docs/alerts/10038/)



##### Medium (High)

### Description

Content Security Policy (CSP) is an added layer of security that helps to detect and mitigate certain types of attacks, including Cross Site Scripting (XSS) and data injection attacks. These attacks are used for everything from data theft to site defacement or distribution of malware. CSP provides a set of standard HTTP headers that allow website owners to declare approved sources of content that browsers should be allowed to load on that page — covered types are JavaScript, CSS, HTML frames, fonts, images and embeddable objects such as Java applets, ActiveX, audio and video files.

* URL: http://juiceshop:3000
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/ftp
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/ftp/
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/ftp/coupons_2013.md.bak
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/ftp/eastere.gg
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/ftp/encrypt.pyc
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/ftp/package-lock.json.bak
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/ftp/package.json.bak
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/ftp/quarantine
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/ftp/suspicious_errors.yml
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/fileServer.js:43:13
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/fileServer.js:59:18
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:280:10
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:286:9
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:328:13
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:365:14
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:376:14
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:421:3
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/layer.js:95:5
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/index.js:145:39
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/sitemap.xml
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``

Instances: 58

### Solution

Ensure that your web server, application server, load balancer, etc. is configured to set the Content-Security-Policy header.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/Security/CSP/Introducing_Content_Security_Policy ](https://developer.mozilla.org/en-US/docs/Web/Security/CSP/Introducing_Content_Security_Policy)
* [ https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html)
* [ https://www.w3.org/TR/CSP/ ](https://www.w3.org/TR/CSP/)
* [ https://w3c.github.io/webappsec-csp/ ](https://w3c.github.io/webappsec-csp/)
* [ https://web.dev/articles/csp ](https://web.dev/articles/csp)
* [ https://caniuse.com/#feat=contentsecuritypolicy ](https://caniuse.com/#feat=contentsecuritypolicy)
* [ https://content-security-policy.com/ ](https://content-security-policy.com/)


#### CWE Id: [ 693 ](https://cwe.mitre.org/data/definitions/693.html)


#### WASC Id: 15

#### Source ID: 3

### [ Cross-Domain Misconfiguration ](https://www.zaproxy.org/docs/alerts/10098/)



##### Medium (Medium)

### Description

Web browser data loading may be possible, due to a Cross Origin Resource Sharing (CORS) misconfiguration on the web server.

* URL: http://juiceshop:3000
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp/
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp/acquisitions.md
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp/announcement_encrypted.md
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp/coupons_2013.md.bak
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp/eastere.gg
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp/encrypt.pyc
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp/incident-support.kdbx
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp/legal.md
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp/package-lock.json.bak
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp/package.json.bak
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp/quarantine
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp/quarantine/juicy_malware_linux_amd_64.url
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp/quarantine/juicy_malware_linux_arm_64.url
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp/quarantine/juicy_malware_macos_64.url
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp/quarantine/juicy_malware_windows_64.exe.url
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/ftp/suspicious_errors.yml
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/build/routes/fileServer.js:43:13
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/build/routes/fileServer.js:59:18
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/build/routes/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/build/routes/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/build/routes/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/build/routes/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/build/routes/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:280:10
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:286:9
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:328:13
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:365:14
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:376:14
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:421:3
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/layer.js:95:5
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/index.js:145:39
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/sitemap.xml
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juiceshop:3000/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`

Instances: 69

### Solution

Ensure that sensitive data is not available in an unauthenticated manner (using IP address white-listing, for instance).
Configure the "Access-Control-Allow-Origin" HTTP header to a more restrictive set of domains, or remove all CORS headers entirely, to allow the web browser to enforce the Same Origin Policy (SOP) in a more restrictive manner.

### Reference


* [ https://vulncat.fortify.com/en/detail?id=desc.config.dotnet.html5_overly_permissive_cors_policy ](https://vulncat.fortify.com/en/detail?id=desc.config.dotnet.html5_overly_permissive_cors_policy)


#### CWE Id: [ 264 ](https://cwe.mitre.org/data/definitions/264.html)


#### WASC Id: 14

#### Source ID: 3

### [ Hidden File Found ](https://www.zaproxy.org/docs/alerts/40035/)



##### Medium (Low)

### Description

A sensitive file was identified as accessible or available. This may leak administrative, configuration, or credential information which can be leveraged by a malicious individual to further attack the system or conduct social engineering efforts.

* URL: http://juiceshop:3000/._darcs
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `HTTP/1.1 200 OK`
  * Other Info: ``
* URL: http://juiceshop:3000/.bzr
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `HTTP/1.1 200 OK`
  * Other Info: ``
* URL: http://juiceshop:3000/.hg
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `HTTP/1.1 200 OK`
  * Other Info: ``
* URL: http://juiceshop:3000/BitKeeper
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `HTTP/1.1 200 OK`
  * Other Info: ``

Instances: 4

### Solution

Consider whether or not the component is actually required in production, if it isn't then disable it. If it is then ensure access to it requires appropriate authentication and authorization, or limit exposure to internal systems or specific source IPs, etc.

### Reference


* [ https://blog.hboeck.de/archives/892-Introducing-Snallygaster-a-Tool-to-Scan-for-Secrets-on-Web-Servers.html ](https://blog.hboeck.de/archives/892-Introducing-Snallygaster-a-Tool-to-Scan-for-Secrets-on-Web-Servers.html)


#### CWE Id: [ 538 ](https://cwe.mitre.org/data/definitions/538.html)


#### WASC Id: 13

#### Source ID: 1

### [ Cross-Domain JavaScript Source File Inclusion ](https://www.zaproxy.org/docs/alerts/10017/)



##### Low (Medium)

### Description

The page includes one or more script files from a third-party domain.

* URL: http://juiceshop:3000
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/main.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/main.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/runtime.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/runtime.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/styles.css
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/styles.css
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/vendor.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/vendor.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/fileServer.js:43:13
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/fileServer.js:43:13
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/fileServer.js:59:18
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/fileServer.js:59:18
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/main.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/main.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/polyfills.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/polyfills.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/runtime.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/runtime.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/styles.css
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/styles.css
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/vendor.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/build/routes/vendor.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/main.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/main.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/runtime.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/runtime.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/styles.css
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/styles.css
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/vendor.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/vendor.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:280:10
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:280:10
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:286:9
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:286:9
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:328:13
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:328:13
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:365:14
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:365:14
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:376:14
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:376:14
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:421:3
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:421:3
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/layer.js:95:5
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/layer.js:95:5
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/main.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/main.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/polyfills.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/polyfills.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/runtime.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/runtime.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/styles.css
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/styles.css
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/vendor.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/vendor.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/main.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/main.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/runtime.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/runtime.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/styles.css
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/styles.css
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/vendor.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/vendor.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/index.js:145:39
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/index.js:145:39
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/main.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/main.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/polyfills.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/polyfills.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/runtime.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/runtime.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/styles.css
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/styles.css
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/vendor.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/vendor.js
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/sitemap.xml
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: ``
* URL: http://juiceshop:3000/sitemap.xml
  * Method: `GET`
  * Parameter: `//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js`
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>`
  * Other Info: ``

Instances: 98

### Solution

Ensure JavaScript source files are loaded from only trusted sources, and the sources can't be controlled by end users of the application.

### Reference



#### CWE Id: [ 829 ](https://cwe.mitre.org/data/definitions/829.html)


#### WASC Id: 15

#### Source ID: 3

### [ Timestamp Disclosure - Unix ](https://www.zaproxy.org/docs/alerts/10096/)



##### Low (Low)

### Description

A timestamp was disclosed by the application/web server. - Unix

* URL: http://juiceshop:3000
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/build/routes/fileServer.js:43:13
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/build/routes/fileServer.js:43:13
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/build/routes/fileServer.js:43:13
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/build/routes/fileServer.js:59:18
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/build/routes/fileServer.js:59:18
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/build/routes/fileServer.js:59:18
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/build/routes/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/build/routes/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/build/routes/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/build/routes/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/build/routes/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/build/routes/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/build/routes/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/build/routes/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/build/routes/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/build/routes/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/build/routes/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/build/routes/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/build/routes/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/build/routes/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/build/routes/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:280:10
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:280:10
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:280:10
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:286:9
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:286:9
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:286:9
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:328:13
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:328:13
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:328:13
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:365:14
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:365:14
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:365:14
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:376:14
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:376:14
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:376:14
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:421:3
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:421:3
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:421:3
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/layer.js:95:5
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/layer.js:95:5
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/layer.js:95:5
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/index.js:145:39
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/index.js:145:39
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/index.js:145:39
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1734944650`
  * Other Info: `1734944650, which evaluates to: 2024-12-23 09:04:10.`
* URL: http://juiceshop:3000/sitemap.xml
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/sitemap.xml
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/sitemap.xml
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`
* URL: http://juiceshop:3000/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1650485437`
  * Other Info: `1650485437, which evaluates to: 2022-04-20 20:10:37.`
* URL: http://juiceshop:3000/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1680327869`
  * Other Info: `1680327869, which evaluates to: 2023-04-01 05:44:29.`
* URL: http://juiceshop:3000/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1701244813`
  * Other Info: `1701244813, which evaluates to: 2023-11-29 08:00:13.`
* URL: http://juiceshop:3000/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1818181818`
  * Other Info: `1818181818, which evaluates to: 2027-08-13 18:30:18.`
* URL: http://juiceshop:3000/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1839622642`
  * Other Info: `1839622642, which evaluates to: 2028-04-17 22:17:22.`
* URL: http://juiceshop:3000/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1863874346`
  * Other Info: `1863874346, which evaluates to: 2029-01-23 14:52:26.`
* URL: http://juiceshop:3000/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1917098446`
  * Other Info: `1917098446, which evaluates to: 2030-10-01 15:20:46.`
* URL: http://juiceshop:3000/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `1981395349`
  * Other Info: `1981395349, which evaluates to: 2032-10-14 19:35:49.`
* URL: http://juiceshop:3000/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2033195021`
  * Other Info: `2033195021, which evaluates to: 2034-06-06 08:23:41.`
* URL: http://juiceshop:3000/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `2038834951`
  * Other Info: `2038834951, which evaluates to: 2034-08-10 15:02:31.`

Instances: 158

### Solution

Manually confirm that the timestamp data is not sensitive, and that the data cannot be aggregated to disclose exploitable patterns.

### Reference


* [ https://cwe.mitre.org/data/definitions/200.html ](https://cwe.mitre.org/data/definitions/200.html)


#### CWE Id: [ 497 ](https://cwe.mitre.org/data/definitions/497.html)


#### WASC Id: 13

#### Source ID: 3

### [ Information Disclosure - Suspicious Comments ](https://www.zaproxy.org/docs/alerts/10027/)



##### Informational (Low)

### Description

The response appears to contain suspicious comments which may help an attacker.

* URL: http://juiceshop:3000/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `query`
  * Other Info: `The following pattern was used: \bQUERY\b and was detected in likely comment: "//owasp.org' target='_blank'>Open Worldwide Application Security Project (OWASP)</a> and is developed and maintained by voluntee", see evidence field for the suspicious comment/snippet.`
* URL: http://juiceshop:3000/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Query`
  * Other Info: `The following pattern was used: \bQUERY\b and was detected in likely comment: "//www.w3.org/2000/svg" viewBox="0 0 512 512"><path d="M0 256C0 397.4 114.6 512 256 512s256-114.6 256-256S397.4 0 256 0S0 114.6 0", see evidence field for the suspicious comment/snippet.`

Instances: 2

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

* URL: http://juiceshop:3000
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/ftp/
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<a href="">ftp</a>`
  * Other Info: `Links have been found that do not have traditional href attributes, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/build/routes/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/build/routes/fileServer.js:43:13
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/build/routes/fileServer.js:59:18
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/build/routes/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/build/routes/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/build/routes/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/build/routes/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/build/routes/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:280:10
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:286:9
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:328:13
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:365:14
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:376:14
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/index.js:421:3
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/layer.js:95:5
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/express/lib/router/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/favicon_js.ico
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/assets/public/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/index.js:145:39
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/main.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/polyfills.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/runtime.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/styles.css
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/juice-shop/node_modules/serve-index/vendor.js
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juiceshop:3000/sitemap.xml
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/3.1.0/cookieconsent.min.js"></script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`

Instances: 50

### Solution

This is an informational alert and so no changes are required.

### Reference




#### Source ID: 3

### [ User Agent Fuzzer ](https://www.zaproxy.org/docs/alerts/10104/)



##### Informational (Medium)

### Description

Check for differences in response based on fuzzed User Agent (eg. mobile sites, access as a Search Engine Crawler). Compares the response statuscode and the hashcode of the response body with the original response.

* URL: http://juiceshop:3000/assets
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1)`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/5.0 (Windows NT 10.0; Trident/7.0; rv:11.0) like Gecko`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3739.0 Safari/537.36 Edg/75.0.109.0`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:93.0) Gecko/20100101 Firefox/91.0`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/5.0 (iPhone; CPU iPhone OS 8_0_2 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12A366 Safari/600.1.4`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_0 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7A341 Safari/528.16`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `msnbot/1.1 (+http://search.msn.com/msnbot.htm)`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets/public
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets/public
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets/public
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1)`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets/public
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/5.0 (Windows NT 10.0; Trident/7.0; rv:11.0) like Gecko`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets/public
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3739.0 Safari/537.36 Edg/75.0.109.0`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets/public
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets/public
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:93.0) Gecko/20100101 Firefox/91.0`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets/public
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets/public
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets/public
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/5.0 (iPhone; CPU iPhone OS 8_0_2 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12A366 Safari/600.1.4`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets/public
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_0 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7A341 Safari/528.16`
  * Evidence: ``
  * Other Info: ``
* URL: http://juiceshop:3000/assets/public
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `msnbot/1.1 (+http://search.msn.com/msnbot.htm)`
  * Evidence: ``
  * Other Info: ``

Instances: 24

### Solution



### Reference


* [ https://owasp.org/wstg ](https://owasp.org/wstg)



#### Source ID: 1


