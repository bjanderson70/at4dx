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
 * @Description: Defines the tests for ApplicationTracer
 *
 **/

@IsTest
private class ApplicationTracerTest {
    
    @isTest
    static void writeTest() {
        // arrange
        Map<String,Boolean> values = new Map<String,Boolean> { 
            'test' => true,
            'another message' => true,
            '' => false,
            null => false
        };
        String lastValid=ApplicationTracer.lastMessage;
        for ( String value : values.keySet() ) {
            ApplicationTracer.trace(value);
            if ( values.get(value) ){ 
                lastValid = value;
            } 
            system.assertEquals(ApplicationTracer.lastMessage, lastValid);
            
        }
    }
    @isTest
    static void writeExceptionTest() {
        // arrange
        NullPointerException excp = new NullPointerException();
        String exceptionMsg = excp.getMessage();

        // act
        ApplicationTracer.trace((Exception)null);
        // assert 
        system.assertEquals(ApplicationTracer.lastMessage, null);
        // act
        ApplicationTracer.trace(excp);
        // assert 
        system.assertEquals(ApplicationTracer.lastMessage, exceptionMsg);
        
    }

    
    @isTest
    static void writePopStatckTest() {
        // arrange

        String  stack = 'AnonymousBlock: line 1, column 1',
                className='AnonymousBlock',
                lineNum='1',
                method='';

        // act / assert
        system.assertEquals('', ApplicationTracer.popStack(''));
        system.assertEquals('', ApplicationTracer.getExecutingMethod(''));
        system.assertEquals('', ApplicationTracer.getExecutingLineNumber(''));
        system.assertEquals('', ApplicationTracer.getExecutingClassName(''));
        

        system.assertEquals(stack, ApplicationTracer.popStack(stack));
        system.assertEquals(method, ApplicationTracer.getExecutingMethod(stack).trim());
        system.assertEquals(lineNum, ApplicationTracer.getExecutingLineNumber(stack).trim());
        system.assertEquals(className, ApplicationTracer.getExecutingClassName(stack).trim());
    }
}