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
 * @Description: Defines application configuration resource
 *
 **/

public virtual with sharing class ApplicationConfigResource extends AbstractApplicationConfiguration {


    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
    // Ctor
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
    /**
     * Default ctor
     * @description tracing is turned on and all triggers are valid
     */
    public ApplicationConfigResource(){
        super(null);
        this.isTracing = true;
    }
    /**
     * ctor
     * @description tracing set and all triggers are valid
     * @param traceMode turn on tracing
     */

    public ApplicationConfigResource(Boolean traceMode){
        super(null);
        this.isTracing = traceMode;
    }
    /**
     * ctor
     * @param traceMode turn on tracing
     * @param domains delimited list of sobject names ( valid delimiters are : comma, tab, newline, whitespace)
     */

    public ApplicationConfigResource(Boolean traceMode, String domains){
        super(domains);
        this.isTracing = traceMode;
    }
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
    // Public Methods
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
    /**
     * isTriggerDisabled description
     * @param  sObjectName sObjectName description
     * @return             return description
     */
    public boolean isTriggerDisabled(String sObjectName) {
        Boolean status = false;
       
        // valid data
        if ( string.isNotBlank(sObjectName)) {
            // if 'all' is present go no further
            status=super.domainObjectNames.contains(ApplicationConfigurationConstants.All);
 
            // if no 'all', check user's domain name
            if ( status == false ) {
                status= super.domainObjectNames.contains(sObjectName.toLowerCase());
            }
        }
        //ApplicationTracer.trace('SObject Name:'+sObjectName + ', isTriggerDisabled:'+status);
        
        return status;
    }// end of isTriggerDisabled
    /**
     * isTracing description
     * @return   return description
     */
    public boolean isTracing(){
        return this.isTracing;
    }
    /**
     * isTracing
     * @description getter/setter of tracing (code trace)
     */
    @TestVisible
    public Boolean isTracing {
        get;
        protected set;
    }

} // end of ApplicationConfigResource