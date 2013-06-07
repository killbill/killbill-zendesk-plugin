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

Requirements
------------

The plugin needs a database to keep a local mapping between Kill Bill account ids and Zendesk user ids (this is to work around indexing delays in Zendesk). The latest version of the schema can be found here: https://raw.github.com/killbill/killbill-zendesk-plugin/master/db/ddl.sql.


Configuration
-------------

The plugin expects a `zendesk.yml` configuration file containing the following:

```
:zendesk:
  :subdomain: 'mysubdomain'
  :username: 'email@domain.com'
  :password: 'password'
# Alternatively, to use Token Authentication or OAuth
#token: 'kX53RIXZKUFhZxSYhRxe7QGFocTkDmmERDxpcddF' 
#access_token: 'kX53RIXZKUFhZxSYhRxe7QGFocTkDmmERDxpcddF'
# Optional
#  :retry: true
```

By default, the plugin will look at the plugin directory root (where `killbill.properties` is located) to find this file.
Alternatively, set the Kill Bill system property `-Dcom.ning.billing.osgi.bundles.jruby.conf.dir=/my/directory` to specify another location.
