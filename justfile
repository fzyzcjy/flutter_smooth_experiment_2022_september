pub-get:
    cd packages/smooth && flutter pub get

build-runner:
    cd packages/smooth && flutter pub run build_runner build --delete-conflicting-outputs

format:
    cd packages/smooth && flutter format . --line-length 120

analyze:
    cd packages/smooth && flutter analyze

all: pub-get build-runner format analyze

publish_all:
    (cd packages/smooth && flutter pub publish --force --server=https://pub.dartlang.org)

benchmark:
    cd packages/smooth/example && flutter drive \
       --driver=test_driver/benchmark_driver.dart \
       --target=integration_test/main_test.dart \
       --no-dds \
       --profile

release old_version new_version:
    grep -q 'version: {{old_version}}' packages/smooth/pubspec.yaml
    grep -q '{{new_version}}' CHANGELOG.md

    sed -i '' 's/version: {{old_version}}/version: {{new_version}}/g' packages/smooth/pubspec.yaml

    git add --all
    git status && git diff --staged | grep ''
    git commit -m "bump from {{old_version}} to {{new_version}}"
    git push

    awk '/## {{new_version}}/{flag=1; next} /## {{old_version}}/{flag=0} flag' CHANGELOG.md | gh release create v{{new_version}} --notes-file "-" --draft --title v{{new_version}}
    echo 'A *DRAFT* release has been created. Please go to the webpage and really release if you find it correct.'
    open https://github.com/fzyzcjy/flutter_smooth/releases

    just publish_all
