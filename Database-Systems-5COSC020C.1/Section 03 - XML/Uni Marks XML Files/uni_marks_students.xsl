<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:template match="/">
      <html>
         <body>
            <center>
               <h2>
                  <i>Westmuni</i>
                  Marks Report - List All Students
               </h2>
            </center>
            <center>
               <table border="1" bordercolor="#000000">
                  <tr bgcolor="#86beda">
                     <th>Student Id</th>
                     <th>Surname</th>
                     <th>First Name</th>
                     <th>Module Code</th>
                     <th>Module Name</th>
                     <th>First Mark</th>
                     <th>Second Mark</th>
                     <th>Final Mark</th>
                     <th>Outcome</th>
                  </tr>
                  <xsl:for-each select="marksreport/module/student">
                     <xsl:sort select="sname" />
                     <xsl:sort select="fname" />
                     <tr>
                        <td>
                           <xsl:value-of select="@studentId" />
                        </td>
                        <td>
                           <xsl:value-of select="sname" />
                        </td>
                        <td>
                           <xsl:value-of select="fname" />
                        </td>
                        <td>
                           <xsl:value-of select="../@moduleCode" />
                        </td>
                        <td>
                           <xsl:value-of select="../modulename" />
                        </td>
                        <td>
                           <xsl:value-of select="mark1" />
                        </td>
                        <td>
                           <xsl:value-of select="mark2" />
                        </td>
                        <td>
                           <xsl:value-of select="0.5*mark1 + 0.5*mark2" />
                        </td>
                        <td>
                           <xsl:choose>
                              <xsl:when test="(0.5*mark1 + 0.5*mark2) &gt;= 40">PASS</xsl:when>
                              <xsl:otherwise>FAIL</xsl:otherwise>
                           </xsl:choose>
                        </td>
                     </tr>
                  </xsl:for-each>
               </table>
            </center>
         </body>
      </html>
   </xsl:template>
</xsl:stylesheet>