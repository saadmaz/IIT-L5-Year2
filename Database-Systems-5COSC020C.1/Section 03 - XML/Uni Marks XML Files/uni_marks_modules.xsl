<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
   <xsl:template match="/">
      <html>
         <body>
            <center>
               <h2>
                  <i>Westmuni</i>
                  Marks Report - List All Modules
               </h2>
            </center>
            <center>
               <xsl:for-each select="marksreport/module">
                  <table border="1" bordercolor="#000000">
                     <tr bgcolor="#86beda">
                        <td colspan="3">
                           <b>
                              <xsl:value-of select="@moduleCode" />
                              -
                              <xsl:value-of select="modulename" />
                           </b>
                        </td>
                        <td colspan="4">
                           <b>
                              Module Leader:
                              <xsl:value-of select="moduleleader" />
                           </b>
                        </td>
                     </tr>
                     <tr bgcolor="#97cfbb">
                        <th>Student Id</th>
                        <th>First Name</th>
                        <th>Surname</th>
                        <th>First Mark</th>
                        <th>Second Mark</th>
                        <th>Final Mark</th>
                        <th>Outcome</th>
                     </tr>
                     <xsl:for-each select="student">
                        <tr>
                           <td>
                              <xsl:value-of select="@studentId" />
                           </td>
                           <td>
                              <xsl:value-of select="fname" />
                           </td>
                           <td>
                              <xsl:value-of select="sname" />
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
                  <br />
               </xsl:for-each>
            </center>
         </body>
      </html>
   </xsl:template>
</xsl:stylesheet>