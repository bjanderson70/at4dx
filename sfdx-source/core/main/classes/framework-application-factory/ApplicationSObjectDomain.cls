/**
 * Copyright (c) 2020, John M. Daniel & John Storey
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
**/

public abstract class ApplicationSObjectDomain 
    extends fflib_SObjectDomain
    implements IApplicationSObjectDomain
{
    

    public IDomainProcessCoordinator getDomainProcessCoordinator()
    {
        return (IDomainProcessCoordinator)di_Injector.Org.getInstance(IDomainProcessCoordinator.class, this);
    }

    public ApplicationSObjectDomain(List<SObject> records) {
        super(records);
        super.Configuration.enableTriggerState();
        // Do the triggers fire?
        // (note, this will require a check within each event as fflib will re-enable the trigger state.
        //  It is not done at the 'IDomainProcessCoordinator' as this is an abstract class that can be inherited
        //  ; thus, we need to ensure all children are blocked as well! )
        this.triggerDisabled = this.determineIfTriggerEventsFire();
        // Disable the base class CRUD checking in preference to explicit checking elsewhere
        Configuration.disableTriggerCRUDSecurity();

    }
    /**
     * domainConfiguration 
     * @description the domain configuration ( for children)
     * @return   IDomainConfiguration domain configuration
     */ 
    public IDomainConfiguration domainConfiguration() {
        return (IDomainConfiguration)CustomSettingResourceMgr.customSetting();
    }
      /**
     * applicationConfiguration 
     * @description the application configuration ( for children)
     * @return   IApplicationConfiguration application configuration
     */ 
    public IApplicationConfiguration applicationConfiguration() {
        return (IApplicationConfiguration)CustomSettingResourceMgr.customSetting();
    }
    /*
     *  Setup the hooks for all of the various trigger contexts to process domain logic injections, if needed.
     */
    public virtual override void handleBeforeInsert()
    {

        if ( this.triggerDisabled==false ) {         
            super.handleBeforeInsert();
            this.getDomainProcessCoordinator().processDomainLogicInjections( DomainProcessConstants.PROCESS_CONTEXT.TriggerExecution, System.TriggerOperation.Before_Insert );
        }
    }

    public virtual override void handleBeforeUpdate(Map<Id,SObject> existingRecords)
    {
        if ( this.triggerDisabled==false ) { 
            super.handleBeforeUpdate( existingRecords );
            this.getDomainProcessCoordinator().processDomainLogicInjections( DomainProcessConstants.PROCESS_CONTEXT.TriggerExecution, System.TriggerOperation.Before_Update, existingRecords );
        }
    }


    public virtual override void handleBeforeDelete()
    {
        if ( this.triggerDisabled==false ) { 
            super.handleBeforeDelete();
            this.getDomainProcessCoordinator().processDomainLogicInjections( DomainProcessConstants.PROCESS_CONTEXT.TriggerExecution, System.TriggerOperation.Before_Delete );
        }
    }

    public virtual override void handleAfterInsert()
    {
        if ( this.triggerDisabled==false ) { 
            super.handleAfterInsert();
            this.getDomainProcessCoordinator().processDomainLogicInjections( DomainProcessConstants.PROCESS_CONTEXT.TriggerExecution, System.TriggerOperation.After_Insert );
        }
    }


    public virtual override void handleAfterUpdate(Map<Id,SObject> existingRecords)
    {
        if ( this.triggerDisabled==false ) { 
            super.handleAfterUpdate( existingRecords );
            this.getDomainProcessCoordinator().processDomainLogicInjections( DomainProcessConstants.PROCESS_CONTEXT.TriggerExecution, System.TriggerOperation.After_Update, existingRecords );
        }
    }

    public virtual override void handleAfterDelete()
    {
        if ( this.triggerDisabled==false ) { 
            super.handleAfterDelete();
            this.getDomainProcessCoordinator().processDomainLogicInjections( DomainProcessConstants.PROCESS_CONTEXT.TriggerExecution, System.TriggerOperation.After_Delete );
        }
    }

    public virtual override void handleAfterUndelete()
    {
        if ( this.triggerDisabled==false ) { 
            super.handleAfterUndelete();
            this.getDomainProcessCoordinator().processDomainLogicInjections( DomainProcessConstants.PROCESS_CONTEXT.TriggerExecution, System.TriggerOperation.After_Undelete );
        }
    }



    /**
     *  Convenience method to expose the fflib_SObjectDomain.SObjectDescribe values to the DomainProcessCoordinator
     */
    public Schema.DescribeSObjectResult getSObjectDescribe()
    {
        return this.SObjectDescribe;
    }

    /**
     * triggerDisabled
     * @description Trigger state from the custom setting ( allow children to change)
     */ 
    @TestVisible
    public Boolean triggerDisabled { get; protected set;}
    /**
     * determineIfTriggerEventsFire 
     * @description check the custom setting ( user/profile) to determine state
     * @return true, if ALL trigger events are disabled
     */ 
    protected Boolean determineIfTriggerEventsFire(){
        Boolean isDisabled = false;
        // setup information for domain configuration
        IDomainConfiguration domain = this.domainConfiguration();
        String name = this.getSObjectDescribe().getName();
        // set the trigger status from the custom setting ( to disable children)
        isDisabled= domain.isTriggerDisabled(name);
        // disable all trigger events within fflib
        if ( isDisabled  ){
            ApplicationTracer.trace('Trigger disabled for domain name: ' + name );
            // bec/ fflib will re-instate the tirgger events; unfortunately, we have to check ( per event :-()!!
            // this does not disable as expected .... fflib_SObjectDomain.getTriggerEvent(Type.forName(name)).disableAll();
        }
        return isDisabled;
    }// end of determineIfTriggerEventsFire

}
