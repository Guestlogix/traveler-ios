# Install tools
gem install jazzy
brew install s3cmd

# Build TravelerKit docs
cd traveler-swift-core
gem install jazzy
jazzy -c

# Upload docs to S3
s3Bucket="s3://$S3_BUCKET_IOS"
s3cmd --access_key=$AWS_ACCESS_KEY
s3cmd --secret_key=$AWS_SECRET_ACCESS_KEY
s3cmd --region=$REGION
s3cmd put --delete-removed --recursive --acl-public ./docs/ $s3Bucket --region=$REGION --access_key=$AWS_ACCESS_KEY --secret_key=$AWS_SECRET_ACCESS_KEY

# Publish CocoaPods
pod trunk push TravelerKit.podspec --allow-warnings

