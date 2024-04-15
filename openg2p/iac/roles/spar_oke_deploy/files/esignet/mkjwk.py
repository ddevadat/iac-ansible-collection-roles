from jwcrypto import jwk
import json

# Generate RSA key pair
key = jwk.JWK.generate(kty='RSA', size=2048)

private_key_json = key.export()
with open('private_key.json', 'w') as private_key_file:
    private_key_file.write(private_key_json)

public_key_json = key.export(private_key=False)
with open('public_key.json', 'w') as public_key_file:
    public_key_file.write(public_key_json)