killbill-zendesk-plugin
=======================

Plugin to mirror Kill Bill data into Zendesk.

User data mapping
-----------------

<table>
  <tr>
    <th>Zendesk attribute</th><th>Value</th>
  </tr>
  <tr>
    <td>name</td><td></td>
  </tr>
  <tr>
    <td>external_id</td><td></td>
  </tr>
  <tr>
    <td>locale</td><td></td>
  </tr>
  <tr>
    <td>locale_id</td><td></td>
  </tr>
  <tr>
    <td>time_zone</td><td></td>
  </tr>
  <tr>
    <td>email</td><td></td>
  </tr>
  <tr>
    <td>phone</td><td></td>
  </tr>
  <tr>
    <td>details</td><td></td>
  </tr>
</table>

Kill Bill identity
------------------

The plugin also creates a killbill identity:

<table>
  <tr>
    <th>Zendesk attribute</th><th>Value</th>
  </tr>
  <tr>
    <td>type</td><td>killbill</td>
  </tr>
  <tr>
    <td>value</td><td><em>Kill Bill account id</em></td>
  </tr>
  <tr>
    <td>verified</td><td>true</td>
  </tr>
</table>


