# Advanced Techniques To Adopt SalesforceDX Unlocked Packages
This is an example set of code to demonstrate the techniques that [@ImJohnMDaniel](https://twitter.com/ImJohnMDaniel) and [@Stohn777](https://twitter.com/stohn777) used to adopt Salesforce DX Unlocked Packages.

The [Wiki](https://github.com/apex-enterprise-patterns/at4dx/wiki) for this codebase goes over these concepts in depth.

Core Frameworks In This Project
-------------------------------
| Folder | Description |
| ------ | ----------- |
| **sfdx-source/core** | Core library, contains the foundation code required to support all of the techniques  |

Sample Code for the frameworks can be found in the related project [AT4DX Sample Code](https://github.com/apex-enterprise-patterns/at4dx-samplecode)


| Folder | Description |
| ------ | ----------- |
| **sfdx-source/reference-implementation-common** | Demonstration code around the Accounts SObject including base domains and selectors.  Also contains examples of [Application Factory Injection](https://github.com/apex-enterprise-patterns/at4dx/wiki/Application-Factory-Injection) |
| **sfdx-source/reference-implementation-marketing** | Demonstration code around the addition of Marketing specific SObject fields on Account.  Also contains examples of [Application Factory Injection](https://github.com/apex-enterprise-patterns/at4dx/wiki/Application-Factory-Injection), [Selector Field Injection](https://github.com/apex-enterprise-patterns/at4dxs/wiki/Selector-Field-Injection), [Domain Process Injection](https://github.com/apex-enterprise-patterns/at4dx/wiki/Domain-Process-Injection), and [Test Data Builder Field Injection](https://github.com/apex-enterprise-patterns/at4dx/wiki/Test-Data-Builder-Field-Injection) |
| **sfdx-source/reference-implementation-sales** | Demonstration code around the addition of Sales specific logic.  Also contains examples of [Application Factory Injection](https://github.com/apex-enterprise-patterns/at4dx/wiki/Application-Factory-Injection), and [Subscription Based Platform Events](https://github.com/apex-enterprise-patterns/at4dx/wiki/Subscription-Based-Platform-Events)  |
| **sfdx-source/reference-implementation-service** | Demonstration code around the addition of Service specific logic.  Also contains examples of [Application Factory Injection](https://github.com/apex-enterprise-patterns/at4dx/wiki/Application-Factory-Injection), and [Subscription Based Platform Events](https://github.com/apex-enterprise-patterns/at4dx/wiki/Subscription-Based-Platform-Events) |
| **sfdx-source/other** | Miscellaeous code.  Used to increase the session settings for a scratch org to be 24 hours |
| **sfdx-source/reference-application-config** | Defines a configuration for the application.  Currently, there is a __at4dx_configuration__ hierarchical custom setting which allows one to set the user or profile's ability to disable trigger invocation. In addition, there is a flag to allow/dis-allow Application tracing. The trigger disabling expects a <comma or semi-colon or whitespace> separated domain name list (i.e. **account, contact**). If you wish to disable all apex triggers, set the textbox to **all**. The setting applies only to a specific user or specific profile. The default setting allows ALL Apex Triggers and Tracing is disabled. |

Setup
-----
This [wiki article](https://github.com/apex-enterprise-patterns/at4dx/wiki/Environment-Setup) gives instructions on how to setup the codebase in a SalesforceDX Scratch org.



