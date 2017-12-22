## T-SQL Developer Test.

To whom it may concern:
Please take the following test as way for us to know to which level your skills match our needs.
If you don’t know how to solve some of the steps don’t give up, simply write what you don’t
understand or if you don’t know how to do it. It will not mean that we will not count with you
for this assignment or any other in the future.
It’s very important that you record the time it takes for you to complete the exercise, it will be
asked to provide with the resulting scripts.
At the end you must provide the scripts you have used to create the tables, stored Procedures
and functions so we can replicate in our servers.

### The exercise:
##### Tables

We are not specifying full specification for fields and indexes. We leave this to your
best knowledge.
1. Site. Create a Site table which will hold the information of the site you are creating. ID
and Name is enough.
2. Contacts. This should include first name and last name of a contact and a link to its
site.
3. Addresses. Include Street Name and Number, City and Country. Country should be and
integer and linked to a Country Table you have to add as well.
4. Phones. Include Phone Number and Type.
5. Populate Site table with two records.
6. Each Site should have three contact examples. And each contact should have, at least
one address and one phone.

##### Stored Procedures

1. Create a Stored Procedure where you enter SIteID as a parameter and you get an XML
content of the Site Info as Root Node and Contacts as First Node and so on so forth.
2. Create a Stored Procedure that you will call Contact_CRUD which will accept two
parameters SIteID and another parameter which will accept XML content.
    * The XML parameter should include a node called ID, when this node has a
value of 0, the Stored Procedure should insert a new Contact in the table.
    * If the ID node has a value > 0, then it should update the appropriate record.
    * If the ID is < 0, then it should delete the record.
    * The stored procedure should return and XML with the content of the entire
site.

Please provide the scripts to replicate them in our servers. We value your effort and interest.
Thanks very much
