---
title: App Files
categories: erb
nav_order: 103
---

If you already have pre-existing files like zip files that need to be uploaded to s3, you can put them in `app/files`.  Example of how the file will upload to s3:

Local path | S3 path
--- | ---
app/files/lambda-function.zip | s3://lono-bucket/cloudformation/development/files/lambda-function-0719ab81.zip

Notice the 0719ab81 is the md5 sum of the file.  This is added automatically beause it is useful if you are uploading the file to be used as a lambda function in a CloudFormation Lambda resource.  You can refer to the file with the `s3_key("lambda-function")` [built-in helper]({% link _docs/erb/helpers/builtin-helpers.md %}).

{% include prev_next.md %}
