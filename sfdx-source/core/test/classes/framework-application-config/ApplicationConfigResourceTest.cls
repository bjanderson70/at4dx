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
 * @Description: Defines the tests for application configuration resource.
 *
 **/

@IsTest
private class ApplicationConfigResourceTest {
    @isTest
    static void ApplicationConfigResourceDefCtorTest(){
        // arrange / act
        ApplicationConfigResource res = new ApplicationConfigResource();
        // assert
        system.assertEquals(true, res.isTracing);
        system.assertEquals(0, res.domainObjectNames.size());

    }
    /**
     * ctor, turn on tracing
     * @param traceMode turn on tracing
     */

    @isTest
    static void  ApplicationConfigResourceCtorWithOneParamTest(){
        // arrange / act
        ApplicationConfigResource res = new ApplicationConfigResource(false);
        // assert
        system.assertEquals(false, res.isTracing);
        system.assertEquals(0, res.domainObjectNames.size());
    }
    /**
     * ctor
     * @param traceMode turn on tracing
     * @param domains delimited list of sobject names ( valid delimiters are : comma, tab, newline, whitespace)
     */

    @isTest
    static void   ApplicationConfigResourceWithTwoParamTest(){
        // arrange 
        String domains = 'account, leads;contact, custom__c\t another__c\n check__c     ;   ,    \n   a s n g yes__c\r\n';
        List<String> expectedDomains = new List<String> {
            'account',
            'contact',
            'custom__c',
            'another__c',
            'check__c',
            'leads',
            'yes__c'
        };
        // act
        ApplicationConfigResource res = new ApplicationConfigResource(false,domains);
        // assert
        system.assertEquals(false, res.isTracing);
        system.assertNotEquals(0, res.domainObjectNames.size());
        for ( String domain: expectedDomains) {
            system.assertEquals(true, res.domainObjectNames.contains(domain.toLowerCase()));
        }
    }
    @isTest
    static void   domainObjectNamesTest(){
        // arrange 
        Map<String,Boolean> expectedDomains = new Map<String,Boolean> {
            'account' => true,
            'contact' => true,
            'custom_c' => false,
            'another__c' => true,
            'an_event__e' => true,
            '' => false,
            '             ' => false,
            '\t ' => false,
            ' \n ' => false,
            ' \r\n ' => false,
            ' b\r\na ' => false, // single characters are not valid
            'all' => true
        };
        // iterate , setting domain and checking
        for ( String domain: expectedDomains.keySet()) {
            ApplicationConfigResource res = new ApplicationConfigResource(false,domain);
            // act / assert
            system.assertEquals((Boolean)expectedDomains.get(domain), res.domainObjectNames.contains(domain.toLowerCase()));
        }
    }
}