See the repository:
- https://github.com/gtrabanco/dotly_secrets

# WARNING
These scripts are not ready and could end in a lost and not recuperable files. Use them carfully.

# 13 Jun 2021 Update

The vars were updated to use macos keychain by providing:

```bash
export DOTLY_SECRETS_VAR_MACOS_STORE="keychain"
```

Default value is `filepath` which use previous way to store vars in a files that, in this case is a git repository.

## Similar stuff to add to store variables

- In Linux: https://blog.scottlowe.org/2016/11/21/gnome-keyring-git-credential-helper/
- In Windows: https://github.com/microsoft/Git-Credential-Manager-Core

## Pending stuff
- [ ] Check if this work throught iCloud
