---
title: Camelize
category: conventions
desc: Hash key conventions.
nav_order: 46
---

Lono generates CloudFormation templates from a [DSL]({% link _docs/dsl.md %}).  As a part of the generation process, Lono camelizes the template keys.  For example this lono DSL code:


```ruby
parameter(:instance_type, "t3.micro")
resource(:my_instance, "AWS::EC2::Instance",
  instance_type: ref(:instance_type),
  image_id: find_in_map(:ami_map, ref("AWS::Region"), :ami),
)
resource(:security_group, "AWS::EC2::SecurityGroup",
  group_description: "demo security group",
)
```

Outputs:

```yaml
Parameters:
  InstanceType:
    Default: t3.micro
    Type: String
Resources:
  MyInstance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType:
        Ref: InstanceType
      ImageId:
        Fn::FindInMap:
        - AmiMap
        - Ref: AWS::Region
        - Ami
  SecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: demo security group
```

Notice how the keys are camelized. Here are some examples:

Key in Code | Output Key
--- | ---
instance_type | InstanceType
my_instance | MyInstance
security_group | SecurityGroup

Methods like [ref]({% link _docs/intrinsic-functions/ref.md %}) and [find_in_map]({% link _docs/intrinsic-functions/ref.md %}) will also camelize the arguments.  For example:

```ruby
instance_type: ref(:instance_type)
```

Produces:

```yaml
InstanceType:
  Ref: InstanceType
```

The convention keeps code looking more natural to Ruby.

## Special Cases: Exceptions and Overrides

For most CloudFormation keys and properties the camelized format is exactly what we want. However, some properties and keys do not expect the strictly camelized versions.  Here are some examples of special cases:

Camelized | Actual
--- | ---
Ttl | TTL
MaxReceiveCount | maxReceiveCount
DeadLetterTargetArn | deadLetterTargetArn
DbSubnetGroupName | DBSubnetGroupName
RoleArn | RoleARN

Moreover, some CloudFormation template resources do not expect camelized keys at all under specific parent keys.  An example is [API Gateway ResponseParameters](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-swagger-extensions-integration-responseParameters.html). Any structure underneath those keys are left untouched.

The special cases list is here: [cfn_camelizer camelizer.yml](https://github.com/tongueroo/cfn_camelizer/blob/master/lib/camelizer.yml).  If you run into a special case that is not covered by the list, please send in a [pull request](https://github.com/tongueroo/cfn_camelizer/pulls) to help others.

You can also add additional special cases your lono project immediately with a `configs/camelizer.yml`:

```yaml
---
special_keys:
  AnotherSpecialKey: anotherSpecialKey
passthrough_parent_keys:
- DontDoAnythingUnderThisParentKey
```

{% include prev_next.md %}