<?xml version="1.0" encoding="UTF-8"?>
<!-- Defines XSL stylesheet and namespace xsl in line with w3.org  -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <!-- Defines templ & associates it w. XML doc -->
   <xsl:template match="/">
      <!-- Indicates that the template should match the whole XML document (start with root element) -->
      <html>
         <body background="background_img.png">
            <center>
               <h2>
                  <i>Dreamhome</i>
                  Estate Agents
               </h2>
            </center>
            <center>
               <table border="1" bordercolor="#9966ff">
                  <tr bgcolor="#0099ff">
                     <th>branchNo</th>
                     <th>StaffNo</th>
                     <th>First Name</th>
                     <th>Last Name</th>
                     <th>Position</th>
                     <th>DOB</th>
                     <th>Salary</th>
                  </tr>
                  <xsl:for-each select="STAFFLIST/STAFF">
                     <!-- Selects every XML elmt of node-set (XPath) -->
                     <tr>
                        <!--  Extracts value of an elmt and adds it to the output stream of transformation -->
                        <td>
                           <xsl:value-of select="@branchNo" />
                        </td>
                        <td>
                           <xsl:value-of select="STAFFNO" />
                        </td>
                        <td>
                           <xsl:value-of select="NAME/FNAME" />
                        </td>
                        <td>
                           <xsl:value-of select="NAME/LNAME" />
                        </td>
                        <td>
                           <xsl:value-of select="POSITION" />
                        </td>
                        <td>
                           <xsl:value-of select="DOB" />
                        </td>
                        <td>
                           <xsl:value-of select="SALARY" />
                        </td>
                     </tr>
                  </xsl:for-each>
               </table>
            </center>
         </body>
      </html>
   </xsl:template>
</xsl:stylesheet>