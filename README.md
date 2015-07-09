# mongodb3-cookbook

[![Build Status](https://travis-ci.org/sunggun-yu/chef-mongodb3.svg?branch=develop)](https://travis-ci.org/sunggun-yu/chef-mongodb3)

TODO: Enter the cookbook description here.

## Supported Platforms

TODO: List your supported platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['mongodb3']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### mongodb3::default

Include `mongodb3` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[mongodb3::default]"
  ]
}
```

## License and Authors

Author:: YOUR_NAME (<YOUR_EMAIL>)
