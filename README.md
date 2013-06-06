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
    <td>name</td><td><em>Kill Bill account name</em></td>
  </tr>
  <tr>
    <td>external_id</td><td><em>Kill Bill account external key</em> if specified, <em>Kill Bill account id</em> otherwise</td>
  </tr>
  <tr>
    <td>locale</td><td><em>Kill Bill account locale</em></td>
  </tr>
  <tr>
    <td>time_zone</td><td><em>Kill Bill account timezone</em></td>
  </tr>
  <tr>
    <td>email</td><td><em>Kill Bill account email</em></td>
  </tr>
  <tr>
    <td>phone</td><td><em>Kill Bill account phone</em></td>
  </tr>
  <tr>
    <td>details</td><td><em>Kill Bill account address1</em>, <em>Kill Bill account address2</em>, <em>Kill Bill account city</em>, <em>Kill Bill account state or province</em>, <em>Kill Bill account postal code</em>, <em>Kill Bill account country</em></td>
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


