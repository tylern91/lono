Lono uses the `config/accounts` and `config/regions` to calculate whether `create-stack-set` or `delete-stack-set` need to be called and calls them accordingly.  You use this instead of `lono sets deploy` when only configs have been adjust and you want to keep the existing template.

Provided:

configs/demo/accounts/development/my-set.txt

    112233445566
    223344556677

configs/demo/regions/development/my-set.txt

    us-east-1
    us-east-2
    us-west-1
    us-west-2

And then we update:

configs/demo/regions/development/my-set.txt

    us-west-1
    us-west-2
    ap-northeast-1
    ap-northeast-2

Running `lono sets instances sync` will delete and add the stack instances accordingly.

    $ lono sets instances sync my-set --blueprint demo
    Using regions for development: configs/demo/regions/development/my-set.sh
    Using accounts for development: configs/demo/accounts/development/my-set.sh
    Are you sure you want to sync stack instances?
    lono will run:
    create_stack_instances for:
      accounts: 112233445566,223344556677
      regions: ap-northeast-1,ap-northeast-2

    Number of stack instances to be created: 4
    delete_stack_instances for:
      accounts: 112233445566,223344556677
      regions: us-east-1,us-east-2

    Number of stack instances to be deleted: 4

    Are you sure? (y/N) y
    => Running create_stack_instances on:
      accounts: 112233445566,223344556677
      regions: ap-northeast-1,ap-northeast-2
    Stack Instance statuses... (takes a while)
    2019-12-19 10:59:07 PM Stack Instance: account 112233445566 region ap-northeast-1 status OUTDATED reason User initiated operation
    2019-12-19 10:59:07 PM Stack Instance: account 223344556677 region ap-northeast-1 status OUTDATED reason User initiated operation
    2019-12-19 10:59:07 PM Stack Instance: account 223344556677 region ap-northeast-2 status OUTDATED reason User initiated operation
    2019-12-19 10:59:07 PM Stack Instance: account 112233445566 region ap-northeast-2 status OUTDATED reason User initiated operation
    2019-12-19 10:59:17 PM Stack Instance: account 112233445566 region ap-northeast-1 status OUTDATED reason User Initiated
    2019-12-19 10:59:26 PM Stack Instance: account 112233445566 region ap-northeast-1 status CURRENT
    2019-12-19 10:59:40 PM Stack Instance: account 223344556677 region ap-northeast-1 status OUTDATED reason User Initiated
    2019-12-19 10:59:49 PM Stack Instance: account 223344556677 region ap-northeast-1 status CURRENT
    2019-12-19 11:00:04 PM Stack Instance: account 112233445566 region ap-northeast-2 status OUTDATED reason User Initiated
    2019-12-19 11:00:17 PM Stack Instance: account 112233445566 region ap-northeast-2 status CURRENT
    2019-12-19 11:00:27 PM Stack Instance: account 223344556677 region ap-northeast-2 status OUTDATED reason User Initiated
    Time took to complete stack set operation: 1m 40s
    Stack set operation completed.
    Stack Set Operation Summary:
    account 112233445566 region ap-northeast-2 status SUCCEEDED
    account 112233445566 region ap-northeast-1 status SUCCEEDED
    account 223344556677 region ap-northeast-2 status SUCCEEDED
    account 223344556677 region ap-northeast-1 status SUCCEEDED
    => Running delete_stack_instances on:
      accounts: 112233445566,223344556677
      regions: us-east-1,us-east-2
    Stack Instance statuses... (takes a while)
    2019-12-19 11:00:40 PM Stack Instance: account 112233445566 region us-east-2 status CURRENT
    2019-12-19 11:00:40 PM Stack Instance: account 112233445566 region us-east-1 status CURRENT
    2019-12-19 11:00:40 PM Stack Instance: account 223344556677 region us-east-2 status CURRENT
    2019-12-19 11:00:40 PM Stack Instance: account 223344556677 region us-east-1 status CURRENT
    2019-12-19 11:00:40 PM Stack Instance: account 223344556677 region us-east-1 status OUTDATED reason User initiated operation
    2019-12-19 11:00:41 PM Stack Instance: account 223344556677 region ap-northeast-2 status CURRENT
    2019-12-19 11:00:44 PM Stack Instance: account 112233445566 region us-east-2 status OUTDATED reason User initiated operation
    2019-12-19 11:00:45 PM Stack Instance: account 112233445566 region us-east-1 status OUTDATED reason User initiated operation
    2019-12-19 11:00:45 PM Stack Instance: account 223344556677 region us-east-2 status OUTDATED reason User initiated operation
    2019-12-19 11:01:03 PM Stack Instance: account 112233445566 region us-east-1 status DELETED
    2019-12-19 11:01:17 PM Stack Instance: account 223344556677 region us-east-1 status DELETED
    2019-12-19 11:01:31 PM Stack Instance: account 112233445566 region us-east-2 status DELETED
    Time took to complete stack set operation: 1m 3s
    Stack set operation completed.
    Stack Set Operation Summary:
    account 112233445566 region us-east-1 status SUCCEEDED
    account 112233445566 region us-east-2 status SUCCEEDED
    account 223344556677 region us-east-2 status SUCCEEDED
    account 223344556677 region us-east-1 status SUCCEEDED
    $