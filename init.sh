#!/bin/sh 
DEMO="JBoss BPM Suite & DV Travel Agency Integration Demo"
AUTHORS="Niraj Patel, Shepherd Chengeta, Van Halbert,"
AUTHORS2="Andrew Block, Eric D. Schabell"
PROJECT="git@github.com:jbossdemocentral/bpms-dv-travel-agency-integration-demo.git"
PRODUCT="JBoss BPM Suite"
JBOSS_HOME=./target/jboss-bpmsuite-6.1
SERVER_DIR=$JBOSS_HOME/standalone/deployments/
SERVER_CONF=$JBOSS_HOME/standalone/configuration/
SERVER_BIN=$JBOSS_HOME/bin
SRC_DIR=./installs
SUPPORT_DIR=./support
PRJ_DIR=./projects
BPMS=jboss-bpmsuite-6.1.0.GA-installer.jar
EAP=jboss-eap-6.4.0-installer.jar
DV=jboss-dv-installer-6.2.0.redhat-3.jar
DV_PRODUCT="JBoss DataVirt"
DV_JBOSS_HOME=./target/jboss-dv-6.2
DV_SERVER_DIR=$DV_JBOSS_HOME/standalone/deployments/
DV_SERVER_CONF=$DV_JBOSS_HOME/standalone/configuration/
DV_SERVER_BIN=$DV_JBOSS_HOME/bin
DV_VERSION=6.2.0
VERSION=6.1


# wipe screen.
clear 

echo
echo "#################################################################################"
echo "##                                                                             ##"   
echo "##  Setting up the                                                             ##"
echo "##                                                                             ##"   
echo "##     ${DEMO}                     ##"
echo "##                                                                             ##"   
echo "##                                                                             ##"   
echo "##   ####  ####   #   #      ### #   # ##### ##### #####       ####  #    #    ##"
echo "##   #   # #   # # # # #    #    #   #   #     #   #       #   #   # #    #    ##"
echo "##   ####  ####  #  #  #     ##  #   #   #     #   ###    ###  #   # #    #    ##"
echo "##   #   # #     #     #       # #   #   #     #   #       #   #   #  #  #     ##"
echo "##   ####  #     #     #    ###  ##### #####   #   #####       ####    ##      ##"
echo "##                                                                             ##"   
echo "##                                                                             ##"   
echo "##  brought to you by,                                                         ##"   
echo "##                                                                             ##"   
echo "##         ${AUTHORS}                        ##"
echo "##         ${AUTHORS2}                                      ##"
echo "##                                                                             ##"   
echo "##  ${PROJECT} ##"
echo "##                                                                             ##"   
echo "#################################################################################"
echo

command -v mvn -q >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed yet... aborting."; exit 1; }

# make some checks first before proceeding.	
if [ -r $SRC_DIR/$EAP ] || [ -L $SRC_DIR/$EAP ]; then
	echo EAP Product sources are present...
	echo
else
	echo Need to download $EAP package from the Customer Portal 
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

if [ -r $SRC_DIR/$EAP_PATCH ] || [ -L $SRC_DIR/$EAP_PATCH ]; then
	echo EAP Product patch sources are present...
	echo
else
	echo Need to download $EAP_PATCH package from the Customer Portal 
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

if [ -r $SRC_DIR/$BPMS ] || [ -L $SRC_DIR/$BPMS ]; then
		echo BPMS Suite sources are present...
		echo
else
		echo Need to download $BPMS package from the Customer Portal 
		echo and place it in the $SRC_DIR directory to proceed...
		echo
		exit
fi

# make some checks first before proceeding.	
if [ -r $SRC_DIR/$DV ] || [ -L $SRC_DIR/$DV ]; then
	echo DV product sources, present...
	echo
else
	echo Need to download $DV package from the Customer Portal 
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

# Remove the old JBoss instance, if it exists.
if [ -x target ]; then
		echo "  - existing JBoss products install removed..."
		echo
		rm -rf target
fi

# Run installers.
echo "JBoss EAP installer running now..."
echo
java -jar $SRC_DIR/$EAP $SUPPORT_DIR/installation-eap -variablefile $SUPPORT_DIR/installation-eap.variables

if [ $? -ne 0 ]; then
	echo
	echo Error occurred during JBoss EAP installation!
	exit
fi

echo
echo "JBoss BPM Suite installer running now..."
echo
java -jar $SRC_DIR/$BPMS $SUPPORT_DIR/installation-bpms -variablefile $SUPPORT_DIR/installation-bpms.variables

if [ $? -ne 0 ]; then
	echo Error occurred during $PRODUCT installation!
	exit
fi

echo
echo "JBoss EAP for DataVirt installer running now..."
echo
java -jar $SRC_DIR/$EAP $SUPPORT_DIR/installation-dv-eap -variablefile $SUPPORT_DIR/installation-dv-eap.variables

if [ $? -ne 0 ]; then
	echo
	echo Error occurred during JBoss EAP installation!
	exit
fi

echo
echo "JBoss DV installer running now..."
echo
java -jar $SRC_DIR/$DV $SUPPORT_DIR/installation-dv -variablefile $SUPPORT_DIR/installation-dv.variables

if [ $? -ne 0 ]; then
	echo Error occurred during DV installation!
	exit
fi

echo
echo "  - enabling demo accounts role setup in application-roles.properties file..."
echo
cp $SUPPORT_DIR/application-roles.properties $SERVER_CONF

echo "  - setting up demo projects..."
echo
cp -r $SUPPORT_DIR/bpm-suite-demo-niogit $SERVER_BIN/.niogit

echo "  - setting up web services..."
echo
mvn clean install -f $PRJ_DIR/pom.xml
cp -r $PRJ_DIR/acme-demo-flight-service/target/acme-flight-service-1.0.war $SERVER_DIR
cp -r $PRJ_DIR/acme-demo-hotel-service/target/acme-hotel-service-1.0.war $SERVER_DIR

echo
echo "  - adding acmeDataModel-1.0.jar to business-central.war/WEB-INF/lib"
cp -r $PRJ_DIR/acme-data-model/target/acmeDataModel-1.0.jar $SERVER_DIR/business-central.war/WEB-INF/lib

echo
echo "  - deploying external-client-ui-form-1.0.war to EAP deployments directory"
cp -r $PRJ_DIR/external-client-ui-form/target/external-client-ui-form-1.0.war $SERVER_DIR/

echo
echo "  - setting up standalone.xml configuration adjustments..."
echo
cp $SUPPORT_DIR/standalone.xml $SERVER_CONF

echo "  - setup email task notification users..."
echo
cp $SUPPORT_DIR/userinfo.properties $SERVER_DIR/business-central.war/WEB-INF/classes/

echo "  - making sure standalone.sh for server is executable..."
echo
chmod u+x $JBOSS_HOME/bin/standalone.sh

echo "  - updating the CustomWorkItemHandler.conf file to use the appropriate email server..."
echo
cp -f $SUPPORT_DIR/CustomWorkItemHandlers.conf $SERVER_DIR/business-central.war/WEB-INF/classes/META-INF

# Optional: uncomment this to install mock data for BPM Suite.
#
#echo - setting up mock bpm dashboard data...
#cp $SUPPORT_DIR/1000_jbpm_demo_h2.sql $SERVER_DIR/dashbuilder.war/WEB-INF/etc/sql
#echo

echo "  - making sure standalone.sh for DV server is executable..."
echo
chmod u+x $DV_JBOSS_HOME/bin/standalone.sh

echo "  - setting up standalone.xml configuration adjustments for DV..."
echo
cp $SUPPORT_DIR/teiidfiles/standalone.xml $DV_SERVER_CONF

echo "  - setup Travel VDB ..."
echo
cp $SUPPORT_DIR/teiidfiles/vdb/* $DV_SERVER_DIR
cp $SUPPORT_DIR/teiidfiles/data/* $DV_SERVER_CONF

echo "  - copy Teiid JDBC Driver ..."
echo
cp $DV_JBOSS_HOME/dataVirtualization/jdbc/teiid-8.*.jar $SERVER_DIR/dashbuilder.war/WEB-INF/lib


echo "  - copy flight and hotel dashboard files ..."
echo 
cp $SUPPORT_DIR/teiidfiles/dashboard/* $SERVER_DIR/dashbuilder.war/WEB-INF/deployments
echo

echo
echo "====================================================================================="
echo "=                                                                                   ="
echo "=  You can now start the $DV_PRODUCT with:                                       ="
echo "=                                                                                   ="
echo "=   $DV_SERVER_BIN/standalone.sh -Djboss.socket.binding.port-offset=100  ="
echo "=                                                                                   ="
echo "=  You can now start the $PRODUCT with:                                      ="
echo "=                                                                                   ="
echo "=   $SERVER_BIN/standalone.sh                                   ="
echo "=                                                                                   ="
echo "=  Login into business central at:                                                  ="
echo "=                                                                                   ="
echo "=    http://localhost:8080/business-central  (u:erics / p:bpmsuite1!)               ="
echo "=                                                                                   ="
echo "=  See README.md for general details to run the various demo cases.                 ="
echo "=                                                                                   ="
echo "=  $DEMO Setup Complete.              ="
echo "=                                                                                   ="
echo "====================================================================================="
echo

