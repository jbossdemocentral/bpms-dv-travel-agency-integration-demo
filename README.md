JBoss BPM Suite and JBoss DataVirt Travel Agency Integration Demo
===========================================================
This is an online employee travel booking process project. It contains multiple web services for looking up data for the process
and rules to calculate pricing. Furthermore, there are several tasks that can be activated to evaluate pricing and to review the
final booking data before completing the booking. Updated data results can be viewed directly in JBoss BPM Suite BAM Dashboards.

The backing services make use of disparate data sources integrated and exposed as services for use in this project.

Welcome to the JBoss BPM Travel Agency!


Option 1 - Install on your machine
----------------------------------
1. [Download and unzip.](https://github.com/jbossdemocentral/bpms-dv-travel-agency-integration-demo/archive/master.zip)

2. Add products to installs directory. For example download and add BPMS installer jar into the installs directory.

3. Run 'init.sh' or 'init.bat' file. 'init.bat' must be run with Administrative privileges.

4. Start JBoss DataVirt Server by running 'standalone.sh  -Djboss.socket.binding.port-offset=100' or 'standalone.bat -Djboss.socket.binding.port-offset=100' in the <path-to-project>/target/jboss-dv-6.2/bin directory

5. Start JBoss BPMS Server by running 'standalone.sh' or 'standalone.bat' in the <path-to-project>/target/jboss-bpmsuite-6.2/bin directory.

6. Login to [http://localhost:8080/business-central](http://localhost:8080/business-central)

    ```
     - login for admin and other roles (u:erics / p:bpmsuite1!)

     - build project: open menu Project Authoring -> Open Project Editor -> Build -> Build & Deploy
    ```
7. Create custom Dashboard entry for monitoring the external JBoss DataVirt virtualized DB views:

    ```
    - select menus Dashboards --> Business Dashboards 

    - select Administration -->  External Connections 

    - select Create New Datasource and select radio box Custom Datasource

    - fill in form as follows:

        - Name: TravelVDB

        - Url:  jdbc:teiid:TravelVDB@mm://localhost:31100

        - DB Driver Class:  select Teiid

        - User:  teiidUser

        - Password:  admin_24

        - Test query:  select 1

    - select Check Datasource, if all goes well then Save this configuration.

    - select in Workspace pulldown menu top left the entry 'Flight and Hotel Bookings' to view virtualized tables and data.

    - monitor these when running process instances.

    ```

8. Submit and process a booking from customer booking form (see Booking a Trip below) - [http://localhost:8080/external-client-ui-form-1.0](http://localhost:8080/external-client-ui-form-1.0)

![Datasource config](https://raw.githubusercontent.com/jbossdemocentral/bpms-dv-travel-agency-integration-demo/master/docs/demo-images/datasource-config-03.png)

![Datasource tables](https://raw.githubusercontent.com/jbossdemocentral/bpms-dv-travel-agency-integration-demo/master/docs/demo-images/datasource-config-05.png)

![Datasource 06](https://raw.githubusercontent.com/jbossdemocentral/bpms-dv-travel-agency-integration-demo/master/docs/demo-images/datasource-config-06.png)

![Datasource 07](https://raw.githubusercontent.com/jbossdemocentral/bpms-dv-travel-agency-integration-demo/master/docs/demo-images/datasource-config-07.png)

Booking a trip 
--------------
1. Assumes you did install and setup as described above (as in option 1).

2. Start process with following data in start form (either from JBoss BPM Suite dashboard or using external client
	 UI deployed at [http://localhost:8080/external-client-ui-form-1.0](http://localhost:8080/external-client-ui-form-1.0)):

  ```
  Name: [your-name]

  Email Adress: [any-email]

  Number of Travellers: 2 

  From Destination: NYC     

  To Destination: Denver

  Preferred Date of Departure: 2015-06-07

  Preferred Data of Arrival: 2015-06-10

  Other Details / Notes: [any-text]
  ```

3. Login to [http://localhost:8080/business-central](http://localhost:8080/business-central)

  ```
  - login for admin role (u:erics / p:bpmsuite1!)
  ```

4. Two web services will be run and a sub-process to calculate the cost before deciding it is not needed that this booking be
	 reviewed on pricing, so you will find a task 'Employee Booking' for you to process.

5. Navigate to the "Tasks" tab and click on it. From the task in the list, click on the "Lock" icon to claim the task

6. Click on the "Work" tab from the resulting right-side pane window that opened.

7. Fill in the form provided for the task, it allows review of all the booking data submitted, generated by services and 
   calculated by the rules. You can request a review to send it back for a pricing review or check the completed box to 
   finish the task and process (isBookingConfirmed). All tasks have automated reassignment, meaning if not completed within 1 minute
   they will be put back into the group.

8. Enter credit card details (beginning with 1234...) for compensation to be triggered., Expiry details of the 
   card (e.g. 12/12) and your full name.

9. Check the logs and you will see that the process has been compensated.

10. To trigger different path for successful booking of Flights, just change the 'Credit Card details' to use any 
    card number that does not begin with 1234....

11. For details on demoing the compensation aspects of the Travel Agency demo project, 
    see [docs/compensation-howto/README-COMPENSATION.md](docs/compensation-howto/README-COMPENSATION.md)


Option 2 - Generate containerized installation
----------------------------------------------
The following steps can be used to configure and run the demo in a container

1. [Download and unzip.](https://github.com/jbossdemocentral/bpms-dv-travel-agency-integration-demo/archive/master.zip)

2. Add products installs directory.

3. Copy Dockerfile and .dockerignore files from support/docker directory to the project root.

4. Build demo image

	```
	docker build -t jbossdemocentral/bpms-dv-travel-agency-integration-demo .
	```
5. Start demo container

	```
	docker run -it -p 9990 -p 9999:9999 -p 8080:8080 -p 31000:31000 -p 10090:10090 -p 10099:10099 -p 8180:8180 jbossdemocentral/bpms-dv-travel-agency-integration-demo
	```
6. Follow the instructions from option 1 above replacing localhost with &lt;DOCKER_HOST&gt; with the exception of the *creating a custom Dashboard entry for monitoring the external JBoss DC virtualized DB views* section

Additional information can be found in the jbossdemocentral container [developer repository](https://github.com/jbossdemocentral/docker-developer)


Supporting Articles
-------------------
- [7 Steps to Your First Process with JBoss BPM Suite Starter	Kit](http://www.schabell.org/2015/08/7-steps-first-process-jboss-bpmsuite-starter-kit.html)

- [Quickest Way into the Clouds with JBoss BPM Travel Agency](http://www.schabell.org/2015/02/into-clouds-with-jboss-bpm-travel-agency.html)

- [Webinar - How to Excite the Travel Industry with a BPM Story](http://www.schabell.org/2015/02/webinar-how-to-excite-travel-industry.html)

- [Slides from webinar - How to excite the travel industry with a BPM story](http://www.schabell.org/2015/02/slides-webinar-jboss-bpm-travel-agency.html)

- [How to fly with the JBoss BPM Travel Agency (video 4 of 4)](http://www.schabell.org/2015/02/how-to-fly-with-jboss-bpm-travel-agency-part4.html)

- [How to fly with the JBoss BPM Travel Agency (video 3 of 4)](http://www.schabell.org/2015/01/how-to-fly-with-jboss-bpm-travel-agency-part3.html)

- [How to fly with the JBoss BPM Travel Agency (video 2 of 4)](http://www.schabell.org/2015/01/how-to-fly-with-jboss-bpm-travel-agency-part2.html)

- [How to fly with the JBoss BPM Travel Agency (video 1 of 4)](http://www.schabell.org/2015/01/how-to-fly-with-jboss-bpm-travel-agency.html)

- [Jump Start Your Rules, Events, Planning and BPM Today](http://www.schabell.org/2014/12/jump-start-rules-events-planning-bpm-today.html)

- [3 Reasons You Need The New JBoss Travel Agency](http://www.schabell.org/2014/12/3-reasons-you-need-new-jboss-travel-agency.html)

- [How To Excite the Travel Industry With a BPM Story](http://www.schabell.org/2014/10/how-to-excite-travel-agencies-with-bpm-story.html)


Released versions
-----------------
See the tagged releases for the following versions of the product:

- v1.3 - JBoss BPM Suite 6.2, JBoss EAP 6.4.3, JBoss DataVirt 6.2 and travel agency project installed using disparate data sources.

- v1.2 - JBoss BPM Suite 6.1, JBoss DataVirt 6.2 and travel agency project using disparate data sources.

- v1.1 - JBoss BPM Suite 6.1, JBoss DataVirt 6.1.1, travel agency project using disparate data sources and containerized installation.

- v1.0 - JBoss BPM Suite 6.1, JBoss DataVirt 6.1.1 and travel agency project using disparate data sources.


[![Video](https://raw.githubusercontent.com/jbossdemocentral/bpms-dv-travel-agency-integration-demo/master/docs/demo-images/video.png)](https://vimeo.com/ericschabell/bpms-dv-travel-agency-integration-demo)

![Announcement](https://raw.githubusercontent.com/jbossdemocentral/bpms-dv-travel-agency-integration-demo/master/docs/demo-images/announce-sign.jpg)

![Datasource 08](https://raw.githubusercontent.com/jbossdemocentral/bpms-dv-travel-agency-integration-demo/master/docs/demo-images/datasource-config-08.png)

![Datasource 06](https://raw.githubusercontent.com/jbossdemocentral/bpms-dv-travel-agency-integration-demo/master/docs/demo-images/datasource-config-06.png)

![Datasource 09](https://raw.githubusercontent.com/jbossdemocentral/bpms-dv-travel-agency-integration-demo/master/docs/demo-images/datasource-config-09.png)

![Datasource 10](https://raw.githubusercontent.com/jbossdemocentral/bpms-dv-travel-agency-integration-demo/master/docs/demo-images/datasource-config-10.png)

