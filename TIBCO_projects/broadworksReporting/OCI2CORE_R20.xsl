<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:c="C">
        <xsl:output method="xml" indent="yes"/>
		
		<!--
			Profile values
		-->
		
		<xsl:variable name="DEFAULT_PROFILE">
				<xsl:text>IMT_CENTREX_gracsas.ims.isonae.com</xsl:text>
		</xsl:variable>
		
		<xsl:variable name="VIRTUAL_PROFILE">
				<xsl:text>IMT_VIRTUAL_gracsas.ims.isonae.com</xsl:text>
		</xsl:variable>
		
		
        <!--
                Transforms the UserAddRequest to a CAI3G-command
        -->
        <xsl:template match="/c:BroadsoftDocument/command[@xsi:type='UserAddRequest' or @xsi:type='UserAddRequest14' or @xsi:type='UserAddRequest14sp9' or @xsi:type='UserAddRequest17sp4']">
		
				<xsl:variable name="USER_ID">
					<xsl:value-of select="userId"/>
				</xsl:variable>
				
				<xsl:variable name="PUBLIC_ID">
					<xsl:text>sip:</xsl:text>
                    <xsl:value-of select="$USER_ID"/>
				</xsl:variable>
				
                <SOAP-ENV:Envelope xmlns:cai3g="http://schemas.ericsson.com/cai3g1.2/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
                        <SOAP-ENV:Header>
                                <cai3g:SessionId/>
                                <cai3g:TransactionId/>
                                <cai3g:SequenceId/>
                        </SOAP-ENV:Header>
                        <SOAP-ENV:Body>
                                <cai3g:Create xmlns:cai3g="http://schemas.ericsson.com/cai3g1.2/">
                                        <cai3g:MOType>IMSSubscription@http://schemas.ericsson.com/ema/UserProvisioning/IMS/5.0/</cai3g:MOType>
                                        <cai3g:MOId>
                                                <subscriberId>
                                                        <xsl:value-of select="$USER_ID"/>
                                                </subscriberId>
                                        </cai3g:MOId>
                                        <cai3g:MOAttributes>
                                            <cssip:createIMSSubscription xmlns:cssip="http://schemas.ericsson.com/ema/UserProvisioning/IMS/5.0/">
											
                                                <subscriberId>
                                                        <xsl:value-of select="$USER_ID"/>
                                                </subscriberId>
												
												<chargingProfID>
														<xsl:text>DefaultChargingProfile</xsl:text>
												</chargingProfID>
												
												<pubData publicIdValue="{$PUBLIC_ID}">
													
													<publicIdValue> 
															<xsl:value-of select="$PUBLIC_ID"/>
													</publicIdValue>
	
													<privateUserId>
															<xsl:value-of select="$USER_ID"/>
													</privateUserId>
															
													<phoneContext>
														<xsl:value-of select = "substring-after($USER_ID,'@')" />
													</phoneContext>
															
													<configuredServiceProfiles configuredServiceProfileId="{$DEFAULT_PROFILE}">
														<configuredServiceProfileId>
															<xsl:value-of select="$DEFAULT_PROFILE"/>
														</configuredServiceProfileId>
													</configuredServiceProfiles>
														
													<xsl:element name="implicitRegSet" >
															<xsl:text>1</xsl:text>
													</xsl:element>
													
													<xsl:element name="isDefault">
															<xsl:text>TRUE</xsl:text>
													</xsl:element>
													<xsl:element name="maxSessions">
															<xsl:text>99</xsl:text>
													</xsl:element> 
												
												</pubData>
												
												<privateUser privateUserId="{$USER_ID}">
													<privateUserId>
														<xsl:value-of select="$USER_ID"/>
													</privateUserId>
													
													<xsl:if test="password">
														<xsl:choose>
															<xsl:when test="password[@xsi:nil='true']"/>
															<xsl:when test="string-length(password) &gt; 0">
																<xsl:element name="userPassword">
																	<xsl:value-of select="password"/>
																</xsl:element>
															</xsl:when>
																<xsl:otherwise>
																	<xsl:element name="userPassword">
																		<xsl:text>DummyPassword</xsl:text>
																	</xsl:element>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:if>
														<xsl:if test="not(password)">
															<xsl:element name="userPassword">
																<xsl:text>DummyPassword</xsl:text>
															</xsl:element>
													</xsl:if>
												</privateUser>
												
											</cssip:createIMSSubscription>
                                        </cai3g:MOAttributes>
                                        <cai3g:extension>
                                                <async:async xmlns:async="http://schemas.ericsson.com/cai3g1.2/extension/EMA/SOS">
                                                        <async:Priority>1</async:Priority>
                                                </async:async>
                                        </cai3g:extension>
                                </cai3g:Create>
                        </SOAP-ENV:Body>
                </SOAP-ENV:Envelope>
        </xsl:template>
		
		
		<!--
                Transforms the UserSetRequest to a CAI3G-command
        -->

        <xsl:template match="/c:BroadsoftDocument/command[@xsi:type='UserModifyRequest' or @xsi:type='UserModifyRequest14' or @xsi:type='UserModifyRequest16' or @xsi:type='UserModifyRequest14sp9' or @xsi:type='UserModifyRequest17sp4']">
		
				<xsl:variable name="USER_ID">
					<xsl:value-of select="userId"/>
				</xsl:variable>
				
				<xsl:variable name="PUBLIC_ID">
					<xsl:text>sip:</xsl:text>
                    <xsl:value-of select="$USER_ID"/>
				</xsl:variable>

				<xsl:if test="phoneNumber">
				
					<SOAP-ENV:Envelope xmlns:cai3g="http://schemas.ericsson.com/cai3g1.2/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
							<SOAP-ENV:Header>
									<cai3g:SessionId/>
									<cai3g:TransactionId/>
									<cai3g:SequenceId/>
							</SOAP-ENV:Header>
							<SOAP-ENV:Body>
									<cai3g:Set xmlns:cai3g="http://schemas.ericsson.com/cai3g1.2/">
											<cai3g:MOType>IMSSubscription@http://schemas.ericsson.com/ema/UserProvisioning/IMS/5.0/</cai3g:MOType>
											<cai3g:MOId>
													<subscriberId>
															<xsl:value-of select="$USER_ID"/>
													</subscriberId>
											</cai3g:MOId>
											<cai3g:MOAttributes>
													<cssip:setIMSSubscription subscriberId="{$USER_ID}" xmlns:cssip="http://schemas.ericsson.com/ema/UserProvisioning/IMS/5.0/">
													
													<xsl:choose>
															<xsl:when test="phoneNumber[@xsi:nil='true']">
																<pubData publicIdValue="{$PUBLIC_ID}">
																		<publicIdTelValue> 
																			<xsl:text>NONE</xsl:text>
																	</publicIdTelValue>
																</pubData>
															</xsl:when>
															<xsl:otherwise>
																	<pubData publicIdValue="{$PUBLIC_ID}">
																		<publicIdTelValue> 
																			<xsl:text>tel:</xsl:text>
																			<xsl:value-of select="phoneNumber"/>
																	</publicIdTelValue>
															</pubData>
															</xsl:otherwise>
													</xsl:choose>
													
													</cssip:setIMSSubscription>
											</cai3g:MOAttributes>
											<cai3g:extension>
													<async:async xmlns:async="http://schemas.ericsson.com/cai3g1.2/extension/EMA/SOS">
															<async:Priority>1</async:Priority>
													</async:async>
											</cai3g:extension>
									</cai3g:Set>
							</SOAP-ENV:Body>
					</SOAP-ENV:Envelope>
					
			    </xsl:if>
        </xsl:template>


		<!--
                Transforms the UserDeleteRequest to a CAI3G-command
        -->
        <xsl:template match="/c:BroadsoftDocument/command[@xsi:type='UserDeleteRequest']">
                <SOAP-ENV:Envelope xmlns:cai3g="http://schemas.ericsson.com/cai3g1.2/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
                        <SOAP-ENV:Header>
                                <cai3g:SessionId/>
                                <cai3g:TransactionId/>
                                <cai3g:SequenceId/>
                        </SOAP-ENV:Header>
                        <SOAP-ENV:Body>
                                <cai3g:Delete xmlns:cai3g="http://schemas.ericsson.com/cai3g1.2/">
                                        <cai3g:MOType>IMSSubscription@http://schemas.ericsson.com/ema/UserProvisioning/IMS/5.0/</cai3g:MOType>
                                        <cai3g:MOId>
                                                <subscriberId>
                                                        <xsl:value-of select="userId"/>
                                                </subscriberId>
                                        </cai3g:MOId>                                   
                               
                                        <cai3g:extension>
                                                <async:async xmlns:async="http://schemas.ericsson.com/cai3g1.2/extension/EMA/SOS">
                                                        <async:Priority>1</async:Priority>
                                                </async:async>
                                        </cai3g:extension> 
                                </cai3g:Delete>
                        </SOAP-ENV:Body>
                </SOAP-ENV:Envelope>
        </xsl:template>


		
		
		<!--
                Transforms the VirtualUserAddRequest to a CAI3G-command
        -->
        <xsl:template match="/c:BroadsoftDocument/command[@xsi:type='GroupAutoAttendantAddInstanceRequest14' or @xsi:type='GroupAutoAttendantAddInstanceRequest20' or @xsi:type='GroupBroadWorksAnywhereAddInstanceRequest' or @xsi:type='GroupCallCenterAddInstanceRequest14' or @xsi:type='GroupCallCenterAddInstanceRequest16' or @xsi:type='GroupCallCenterAddInstanceRequest14sp3' or @xsi:type='GroupCallCenterAddInstanceRequest14sp9' or @xsi:type='GroupCallCenterAddInstanceRequest17sp3' or @xsi:type='GroupCallCenterAddInstanceRequest19' or @xsi:type='GroupHuntGroupAddInstanceRequest14' or @xsi:type='GroupHuntGroupAddInstanceRequest17sp4' or @xsi:type='GroupHuntGroupAddInstanceRequest20' or @xsi:type='GroupInstantConferencingAddInstanceRequest14' or @xsi:type='GroupInstantGroupCallAddInstanceRequest14' or @xsi:type='GroupAutoAttendantAddInstanceRequest16' or @xsi:type='GroupAutoAttendantAddInstanceRequest17sp1']">
		
		
				<xsl:variable name="VIRTUAL_USER_ID">
					<xsl:value-of select="serviceUserId"/>
				</xsl:variable>
				
				<xsl:variable name="PUBLIC_ID">
					<xsl:text>sip:</xsl:text>
                    <xsl:value-of select="$VIRTUAL_USER_ID"/>
				</xsl:variable>
				
                <SOAP-ENV:Envelope xmlns:cai3g="http://schemas.ericsson.com/cai3g1.2/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
                        <SOAP-ENV:Header>
                                <cai3g:SessionId/>
                                <cai3g:TransactionId/>
                                <cai3g:SequenceId/>
                        </SOAP-ENV:Header>
                        <SOAP-ENV:Body>
                                <cai3g:Create xmlns:cai3g="http://schemas.ericsson.com/cai3g1.2/">
                                        <cai3g:MOType>IMSSubscription@http://schemas.ericsson.com/ema/UserProvisioning/IMS/5.0/</cai3g:MOType>
                                        <cai3g:MOId>
                                                <subscriberId>
                                                        <xsl:value-of select="$VIRTUAL_USER_ID"/>
                                                </subscriberId>
                                        </cai3g:MOId>
                                        <cai3g:MOAttributes>
                                            <cssip:createIMSSubscription xmlns:cssip="http://schemas.ericsson.com/ema/UserProvisioning/IMS/5.0/">
											
                                                <subscriberId>
                                                        <xsl:value-of select="$VIRTUAL_USER_ID"/>
                                                </subscriberId>
												
												<chargingProfID>
														<xsl:text>DefaultChargingProfile</xsl:text>
												</chargingProfID>
												
												<pubData publicIdValue="{$PUBLIC_ID}">
													
													<publicIdValue> 
															<xsl:value-of select="$PUBLIC_ID"/>
													</publicIdValue>
	
													<privateUserId>
															<xsl:value-of select="$VIRTUAL_USER_ID"/>
													</privateUserId>
													
													<subscriberServiceProfileId>
															<xsl:value-of select="$VIRTUAL_USER_ID"/>
													</subscriberServiceProfileId>
															
												<!--	<phoneContext>
														<xsl:value-of select = "substring-after($VIRTUAL_USER_ID,'@')" />
													</phoneContext>
												-->
													<configuredServiceProfiles configuredServiceProfileId="{$VIRTUAL_PROFILE}">
														<configuredServiceProfileId>
															<xsl:value-of select="$VIRTUAL_PROFILE"/>
														</configuredServiceProfileId>
													</configuredServiceProfiles>
														
													<xsl:element name="implicitRegSet" >
															<xsl:text>0</xsl:text>
													</xsl:element>
													
													<xsl:element name="isDefault">
															<xsl:text>FALSE</xsl:text>
													</xsl:element>
													<xsl:element name="maxSessions">
															<xsl:text>99</xsl:text>
													</xsl:element> 
												
												</pubData>
												
												<privateUser privateUserId="{$VIRTUAL_USER_ID}">
													<privateUserId>
														<xsl:value-of select="$VIRTUAL_USER_ID"/>
													</privateUserId>
													
													<xsl:if test="password">
														<xsl:choose>
															<xsl:when test="password[@xsi:nil='true']"/>
															<xsl:when test="string-length(password) &gt; 0">
																<xsl:element name="userPassword">
																	<xsl:value-of select="password"/>
																</xsl:element>
															</xsl:when>
																<xsl:otherwise>
																	<xsl:element name="userPassword">
																		<xsl:text>DummyPassword</xsl:text>
																	</xsl:element>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:if>
														<xsl:if test="not(password)">
															<xsl:element name="userPassword">
																<xsl:text>DummyPassword</xsl:text>
															</xsl:element>
													</xsl:if>
											
												</privateUser>
                                                </cssip:createIMSSubscription>
                                        </cai3g:MOAttributes>
                                        <cai3g:extension>
                                                <async:async xmlns:async="http://schemas.ericsson.com/cai3g1.2/extension/EMA/SOS">
                                                        <async:Priority>1</async:Priority>
                                                </async:async>
                                        </cai3g:extension>
                                </cai3g:Create>
                        </SOAP-ENV:Body>
                </SOAP-ENV:Envelope>
		</xsl:template>
		
		
        
        <!--
                Transforms the VirtualUserSetRequest to a CAI3G-command
        -->
        <xsl:template match="/c:BroadsoftDocument/command[@xsi:type='GroupAutoAttendantModifyInstanceRequest' or @xsi:type='GroupAutoAttendantModifyInstanceRequest16' or @xsi:type='GroupAutoAttendantModifyInstanceRequest17sp1' or @xsi:type='GroupBroadWorksAnywhereModifyInstanceRequest' or @xsi:type='GroupCallCenterModifyInstanceRequest' or @xsi:type='GroupCallCenterModifyInstanceRequest16' or @xsi:type='GroupCallCenterModifyInstanceRequest17sp1' or @xsi:type='GroupHuntGroupModifyInstanceRequest' or @xsi:type='GroupInstantConferencingModifyInstanceRequest' or @xsi:type='GroupInstantConferencingModifyInstanceRequest16' or @xsi:type='GroupInstantGroupCallModifyInstanceRequest' or @xsi:type='GroupAutoAttendantModifyInstanceRequest20' or @xsi:type='GroupCallCenterModifyInstanceRequest19']">
		
		
				<xsl:variable name="VIRTUAL_USER_ID">
					<xsl:value-of select="serviceUserId"/>
				</xsl:variable>
				
				<xsl:variable name="PUBLIC_ID">
					<xsl:text>sip:</xsl:text>
                    <xsl:value-of select="$VIRTUAL_USER_ID"/>
				</xsl:variable>
				
				<xsl:if test="serviceInstanceProfile/phoneNumber">
		
					<SOAP-ENV:Envelope xmlns:cai3g="http://schemas.ericsson.com/cai3g1.2/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
							<SOAP-ENV:Header>
									<cai3g:SessionId/>
									<cai3g:TransactionId/>
									<cai3g:SequenceId/>
							</SOAP-ENV:Header>
							<SOAP-ENV:Body>
									<cai3g:Set xmlns:cai3g="http://schemas.ericsson.com/cai3g1.2/">
											<cai3g:MOType>IMSSubscription@http://schemas.ericsson.com/ema/UserProvisioning/IMS/5.0/</cai3g:MOType>
											<cai3g:MOId>
													<subscriberId>
															<xsl:value-of select="$VIRTUAL_USER_ID"/>
													</subscriberId>
											</cai3g:MOId>
											<cai3g:MOAttributes>
													<cssip:setIMSSubscription subscriberId="{$VIRTUAL_USER_ID}" xmlns:cssip="http://schemas.ericsson.com/ema/UserProvisioning/IMS/5.0/">
	
													<xsl:choose>
															<xsl:when test="serviceInstanceProfile/phoneNumber[@xsi:nil='true']">
																<pubData publicIdValue="{$PUBLIC_ID}">
																		<publicIdTelValue> 
																			<xsl:text>NONE</xsl:text>
																	</publicIdTelValue>
																</pubData>
															</xsl:when>
															<xsl:otherwise>
																	<pubData publicIdValue="{$PUBLIC_ID}">
																		<publicIdTelValue> 
																			<xsl:text>tel:</xsl:text>
																			<xsl:value-of select="serviceInstanceProfile/phoneNumber"/>
																	</publicIdTelValue>
															</pubData>
															</xsl:otherwise>
													</xsl:choose>
											
													</cssip:setIMSSubscription>
											</cai3g:MOAttributes>
											<cai3g:extension>
													<async:async xmlns:async="http://schemas.ericsson.com/cai3g1.2/extension/EMA/SOS">
															<async:Priority>1</async:Priority>
													</async:async>
											</cai3g:extension>
									</cai3g:Set>
							</SOAP-ENV:Body>
					</SOAP-ENV:Envelope>
				</xsl:if>
        </xsl:template>
                        
        
        
        <!--
                Transforms the VirtualUserDeleteRequest to a CAI3G-command
        -->
        <xsl:template match="/c:BroadsoftDocument/command[@xsi:type='GroupAutoAttendantDeleteInstanceRequest' or @xsi:type='GroupBroadWorksAnywhereDeleteInstanceRequest' or @xsi:type='GroupCallCenterDeleteInstanceRequest' or @xsi:type='GroupHuntGroupDeleteInstanceRequest' or @xsi:type='GroupInstantConferencingDeleteInstanceRequest' or @xsi:type='GroupInstantGroupCallDeleteInstanceRequest']">

				<SOAP-ENV:Envelope xmlns:cai3g="http://schemas.ericsson.com/cai3g1.2/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
                        <SOAP-ENV:Header>
                                <cai3g:SessionId/>
                                <cai3g:TransactionId/>
                                <cai3g:SequenceId/>
                        </SOAP-ENV:Header>
                        <SOAP-ENV:Body>
                                <cai3g:Delete xmlns:cai3g="http://schemas.ericsson.com/cai3g1.2/">
                                        <cai3g:MOType>IMSSubscription@http://schemas.ericsson.com/ema/UserProvisioning/IMS/5.0/</cai3g:MOType>
                                        <cai3g:MOId>
                                                <subscriberId>
                                                        <xsl:value-of select="serviceUserId"/>
                                                </subscriberId>
                                        </cai3g:MOId>                                   
                               
                                        <cai3g:extension>
                                                <async:async xmlns:async="http://schemas.ericsson.com/cai3g1.2/extension/EMA/SOS">
                                                        <async:Priority>1</async:Priority>
                                                </async:async>
                                        </cai3g:extension> 
                                </cai3g:Delete>
                        </SOAP-ENV:Body>
                </SOAP-ENV:Envelope>
        </xsl:template>

		
		<!--
                Transforms the UserBusyLampFieldModifyRequest to a CAI3G-command
		-->
		
		<xsl:template match="/c:BroadsoftDocument/command[@xsi:type='UserBusyLampFieldModifyRequest']">
		
				<xsl:variable name="USER_ID">
					<xsl:value-of select="userId"/>
				</xsl:variable>
		
				<xsl:variable name="BLF_USER_ID">
					<xsl:value-of select="listURI"/>
				</xsl:variable>
				
				<xsl:variable name="BLF_PUBLIC_ID">
					<xsl:text>sip:</xsl:text>
                    <xsl:value-of select="$BLF_USER_ID"/>
				</xsl:variable>
				
                <SOAP-ENV:Envelope xmlns:cai3g="http://schemas.ericsson.com/cai3g1.2/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
                    <SOAP-ENV:Header>
                            <cai3g:SessionId/>
                            <cai3g:TransactionId/>
                            <cai3g:SequenceId/>
                    </SOAP-ENV:Header>
                    <SOAP-ENV:Body>
					<xsl:choose>
					<xsl:when test="listURI[@xsi:nil='true']">
						<cai3g:Delete xmlns:cai3g="http://schemas.ericsson.com/cai3g1.2/">
 							<cai3g:MOType>IMSSubscription@http://schemas.ericsson.com/ema/UserProvisioning/IMS/5.0/</cai3g:MOType>
                                    <cai3g:MOId>
                                        <subscriberId>
									<xsl:text>BLF_</xsl:text>
                                            <xsl:value-of select="$USER_ID"/>
                                        </subscriberId>
                                    </cai3g:MOId>                                   
                                    <cai3g:extension>
                                            <async:async xmlns:async="http://schemas.ericsson.com/cai3g1.2/extension/EMA/SOS">
                                                    <async:Priority>1</async:Priority>
                                            </async:async>
                                    </cai3g:extension> 
						</cai3g:Delete>
 					</xsl:when>
					<xsl:otherwise>
							<cai3g:Create xmlns:cai3g="http://schemas.ericsson.com/cai3g1.2/">
                                    <cai3g:MOType>IMSSubscription@http://schemas.ericsson.com/ema/UserProvisioning/IMS/5.0/</cai3g:MOType>
                                    <cai3g:MOId>
                                            <subscriberId>
                                                    <xsl:value-of select="$BLF_USER_ID"/>
                                            </subscriberId>
                                    </cai3g:MOId>
                                    <cai3g:MOAttributes>
                                        <cssip:createIMSSubscription xmlns:cssip="http://schemas.ericsson.com/ema/UserProvisioning/IMS/5.0/">
                                            <subscriberId>
                                                    <xsl:value-of select="$BLF_USER_ID"/>
                                            </subscriberId>
											<chargingProfID>
												<xsl:text>DefaultChargingProfile</xsl:text>
											</chargingProfID>
											<pubData publicIdValue="{$BLF_PUBLIC_ID}">
												<publicIdValue> 
														<xsl:value-of select="$BLF_PUBLIC_ID"/>
												</publicIdValue>
												<privateUserId>
														<xsl:value-of select="$BLF_USER_ID"/>
												</privateUserId>
												<subscriberServiceProfileId>
														<xsl:value-of select="$BLF_USER_ID"/>
												</subscriberServiceProfileId>
												<!--	<phoneContext>
													<xsl:value-of select = "substring-after($VIRTUAL_USER_ID,'@')" />
												</phoneContext>
												-->
												<configuredServiceProfiles configuredServiceProfileId="{$VIRTUAL_PROFILE}">
													<configuredServiceProfileId>
														<xsl:value-of select="$VIRTUAL_PROFILE"/>
													</configuredServiceProfileId>
												</configuredServiceProfiles>
												<xsl:element name="implicitRegSet" >
														<xsl:text>0</xsl:text>
												</xsl:element>
												<xsl:element name="isDefault">
														<xsl:text>FALSE</xsl:text>
												</xsl:element>
												<xsl:element name="maxSessions">
														<xsl:text>99</xsl:text>
												</xsl:element> 
											</pubData>
											<privateUser privateUserId="{$BLF_USER_ID}">
												<privateUserId>
													<xsl:value-of select="$BLF_USER_ID"/>
												</privateUserId>
												<xsl:if test="password">
													<xsl:choose>
														<xsl:when test="password[@xsi:nil='true']"/>
														<xsl:when test="string-length(password) &gt; 0">
															<xsl:element name="userPassword">
																<xsl:value-of select="password"/>
															</xsl:element>
														</xsl:when>
															<xsl:otherwise>
																<xsl:element name="userPassword">
																	<xsl:text>DummyPassword</xsl:text>
																</xsl:element>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:if>
													<xsl:if test="not(password)">
														<xsl:element name="userPassword">
															<xsl:text>DummyPassword</xsl:text>
														</xsl:element>
												</xsl:if>
											</privateUser>
										</cssip:createIMSSubscription>
                                    </cai3g:MOAttributes>
                                    <cai3g:extension>
                                            <async:async xmlns:async="http://schemas.ericsson.com/cai3g1.2/extension/EMA/SOS">
                                                    <async:Priority>1</async:Priority>
                                            </async:async>
                                    </cai3g:extension>
                            </cai3g:Create>
						</xsl:otherwise>
                        </xsl:choose>
                    </SOAP-ENV:Body>
                </SOAP-ENV:Envelope>
        </xsl:template>
		

       <!--
                Declares the OCIReportingServerStatusNotification as a Keep Alive Message
        -->
        <xsl:template match="/BroadsoftOCIReportingDocument/command[@xsi:type='OCIReportingServerStatusNotification']">
                <xsl:text>KeepAliveMessage</xsl:text>
        </xsl:template>


        <!--
                Extracts the userId from the OCIReportingReportNotification
        -->
        <xsl:template match="/BroadsoftOCIReportingDocument/command[@xsi:type='OCIReportingReportNotification']">
                <xsl:value-of select="userId"/>
        </xsl:template>


        <!--
                Collect xml messages that doesn't fit into the other templates
        -->
        <xsl:template match="text()|@*"/>
		
</xsl:stylesheet>
