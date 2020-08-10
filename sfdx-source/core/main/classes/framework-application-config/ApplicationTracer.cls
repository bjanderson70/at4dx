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
 * @Description: Defines a very rudimentary tracer ( much borrowed from github.com/bjanderson70)
 * (abstract -- do not allow instantiation)
 **/

public abstract with sharing class ApplicationTracer {
    
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
    // Data Members
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
    // get trace status
    static final boolean traceOn = ((IApplicationConfiguration)CustomSettingResourceMgr.customSetting()).isTracing();
    // where are down in the stack
    static final Integer STACK_TRACE_DOWN = 7;
    // last written message
    @TestVisible
    static String lastMessage = null;

    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
    // Public Methods
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
    /**
     * trace
     * @description tracer
     * @param  message message to print out
     */
    public static void trace(String message){
        if ( String.isNotBlank(message) ) {
            ApplicationTracer.write(message);
        }
    }

    /**
     * trace
     * @description tracer
     * @param  message exception message to print out
     */
    public static void trace(Exception message){
        if ( message != null  ) {
            ApplicationTracer.write(message.getMessage());
        }
    }
    /**
     * trace
     * @description tracer (sf data)
     */
    public static void trace(){
        // get limits for tracing
        ApplicationTracer.write(
            'Heap ['+ Limits.getHeapSize()       + ' bytes]'
            +', CPU ['+ Limits.getCpuTime()      + ' ms]'
            +', DML ['+ Limits.getDMLStatements()+ ' ]'
            +', Queries ['+ Limits.getQueries()  + ' ]'
            );
    }
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
    // Private Methods
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=

    /**
     * write
     * @description write a message -- this should be ALL you have to modify
     * @param  message data to print
     * @return void
     */
    @TestVisible
    private static void write(String message){
        ApplicationTracer.lastMessage = message;

        if ( String.isNotBlank(message)
             // chicken and the egg. If you attempt to perform a Application.Tracer before we are created; check for null as well
             && ( ApplicationTracer.traceOn != null && ApplicationTracer.traceOn)) {

            string trace = ApplicationTracer.popStack(new DmlException().getStackTraceString());
            // not loving system.debug! but this is crude and rude!
            system.debug(
                '++++> Tracer: Class[' + getExecutingClassName(trace) + ' ] '
                + 'Method[' + getExecutingMethod(trace) + ' ] '
                + 'Line #[' + +getExecutingLineNumber(trace)  + ' ] '
                + 'Message: '
                + message);
        }
    }
    /********************************************************************************************
     * Copied these from my repo ...
     *       accc_ApexUtilities.cls (https://github.com/bjanderson70/sf-cross-cutting-concerns)
     */

    /**
     *  getExecutingClassName
     *  @description get the executing class name from an stack trace
     *
     * @param string stack trace
     * @return string class name
     */
    @TestVisible
    private static String getExecutingClassName(String line) {
        String result = '';
        if ( !string.isblank(line) ) {
            final string tag = 'Class.';
            if (line.startsWith(tag) ) {
                line = line.substringAfter(tag);
            }
            if ( !string.isblank(line) ) {
                result = line.substringBefore(':').substringBeforeLast('.');
            }
        }
       
        return result;
    } // end of getExecutingClassName

    /**
     *  getExecutingLineNumber
     *  @description get the executing lineno from an stack trace
     *
     * @param String stack trace
     * @return string line number
     */
    @TestVisible
    private static String getExecutingLineNumber(String line) {
        String result = '';
        if ( !string.isblank(line) ) {
            final string tag = 'Class.';
            if (line.startsWith(tag) ) {
                line = line.substringAfter(tag);
            }
            if ( !string.isblank(line) ) {
                result = line.substringBetween('line', ',');
            }
        }
  
        return result;
    } // end of getExecutingLineNumber

    /**
     * getExecutingMethod
     * @description get the executing method name from an stack trace
     *
     * @param line from the stack trace
     * @return method name
     */
    @TestVisible
    private static String getExecutingMethod(String line) {
        String result = '';
        if ( !string.isblank(line) ) {
            line = line.substringBefore(':');
            if ( !string.isblank(line) ) {
                result = line.substringAfterLast('.');
            }
        }
   
        return result;
    } // end of getExecutingMethod

    /**
     * popStack
     * @description pop the stack to get to the right level of the stack
     *
     * @param strack trace
     * @return one from top level of the stack
     */
    @TestVisible
    private static string popStack(string trace) {
        string popTrace = '';
 
        if ( !string.isBlank(trace) ) {
            List<String> lines = trace.split('\\n');
            // 'STACK_TRACE_DOWN'  in the stack
            integer location = lines.size()-STACK_TRACE_DOWN;
    
            if ( location < 0 ) {
                location = 0;
            }

            popTrace = lines[location]!=null?lines[location]:'';
        }
        
        return popTrace;
    } // end of popStack

}// end of ApplicationTracer