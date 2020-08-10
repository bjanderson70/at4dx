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
 * @Description: Defines custom setting resource manager
 *
 **/

public with sharing class CustomSettingResourceMgr {


    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
    // Data Members
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
    // grab per transaction
    @TestVisible
    static AbstractApplicationConfiguration configuration=null;

    static {
        // null -- check, initialized in test
        if (  CustomSettingResourceMgr.configuration==null){ 
            at4dx_Configuration__c userApplicationConfig = at4dx_Configuration__c.getInstance();
            // if null we will get it in the static call
            if (  userApplicationConfig!=null ) {
                CustomSettingResourceMgr.configuration=CustomSettingResourceMgr.convertConfigurationToResource(userApplicationConfig);
            }
        }
    }

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
    // Public Methods
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
    /**
     * customSetting
     * @description pull the custom setting information
     * @return   return ApplicationConfigResource (DAO)
     */
    public static AbstractApplicationConfiguration customSetting()
    {

        // have a configuration
        if ( CustomSettingResourceMgr.configuration == null ) {
            at4dx_Configuration__c appConfig = at4dx_Configuration__c.getInstance();

            if ( appConfig == null )
            {
                appConfig = new at4dx_Configuration__c();
                appConfig.SetupOwnerId = ConnectApi.Organization.getSettings().orgId;
                // make CheckMarx happy
                if (at4dx_Configuration__c.SObjectType.getDescribe().isCreateable() )
                {
                    insert appConfig;
                }
            }
            // set configuration (dao)
            CustomSettingResourceMgr.configuration=CustomSettingResourceMgr.convertConfigurationToResource(appConfig);
        }

        return CustomSettingResourceMgr.configuration;
    }// end of customSetting

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
    // Private Methods
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
    /**
     * convertConfigurationToResource
     * @description convert custom setting to a resource for consumption
     * @param  appConfig appConfig configuration
     * @return   ApplicationConfigResource
     */
    @TestVisible
    private static AbstractApplicationConfiguration convertConfigurationToResource(at4dx_Configuration__c appConfig){
        // there are two domain entries ( as we are limited to 255 chars.); that SHOULD be enough!!
        String domains = appConfig.disableTriggersBySObjectName__c==null ? '' : appConfig.disableTriggersBySObjectName__c;
        domains += appConfig.disableTriggersBySObjectNameContinue__c==null ? '' : appConfig.disableTriggersBySObjectNameContinue__c;
        // by default tracing is off;
        Boolean tracing = appConfig.Is_Tracing__c == null ? false :appConfig.Is_Tracing__c;

        // return our DAO
        return new ApplicationConfigResource(tracing,domains);
    }// end of convertConfigurationToResource

}// end of CustomSettingResourceMgr