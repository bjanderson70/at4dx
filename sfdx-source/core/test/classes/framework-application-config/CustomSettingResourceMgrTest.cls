/**
 * Copyright (c) 2020
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the John M. Daniel, nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * @Author: Bill Anderson
 * @Description: Defines the tests for custom setting resource manager.
 *
 **/

@IsTest
private class  CustomSettingResourceMgrTest {
    
    @isTest
    static void customSettingTest(){

         // arrange (note, 'a' and 'b' should be ignored)
         final String DOMAINS = 'account, lead CONTACT a b; custom__c; cc , cc__ a__ ; __e';
         final List<String> expectedDisabledDomains = new  List<String> {
             'account','lead','contact', 'custom__c' 
         };
 
        // create a new resource         
        ApplicationConfigResource res = new ApplicationConfigResource(true,DOMAINS);
        // reseed the configuration
        CustomSettingResourceMgr.configuration = res;
        
         // act 
         AbstractApplicationConfiguration config = (AbstractApplicationConfiguration)CustomSettingResourceMgr.customSetting();
        
        // apex does not recognize inherited interfaces !!!
        IApplicationConfiguration appConfig = (IApplicationConfiguration)config;
        // apex does not recognize inherited interfaces !!!          
        IDomainConfiguration domainConfig = (IDomainConfiguration)config;

         // assert
         system.assert(true,appConfig.isTracing());
         for (String domain: expectedDisabledDomains){
            // expected true
            system.assert(true,domainConfig.isTriggerDisabled(domain));
         }
         // assert domains are as expected
         system.assertEquals(config.domainObjectNames.size(), expectedDisabledDomains.size());

    }
}