//
//  Signer.swift
//  Secp256k1Signing
//
//  Created by iOS on 2021/12/1.
//

import Foundation
import CommonCrypto
import secp256k1

public func signSawtoothSigning(data: [UInt8], privateKey: [UInt8]) throws -> Data {
    let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))
    var sig = secp256k1_ecdsa_signature()

    var msgDigest = signerHash(data: data)
    let resultSign = msgDigest.withUnsafeMutableBytes { (msgDigestBytes) in
        secp256k1_ecdsa_sign(ctx!, &sig, msgDigestBytes, privateKey, nil, nil)
    }
    if resultSign == 0 {
        throw SigningError.invalidPrivateKey
    }

    var input: [UInt8] {
        var tmp = sig.data
        return [UInt8](UnsafeBufferPointer(start: &tmp.0, count: MemoryLayout.size(ofValue: tmp)))
    }
    var compactSig = secp256k1_ecdsa_signature()

    if secp256k1_ecdsa_signature_parse_compact(ctx!, &compactSig, input) == 0 {
        secp256k1_context_destroy(ctx)
        throw SigningError.invalidSignature
    }

    var csigArray: [UInt8] {
        var tmp = compactSig.data
        return [UInt8](UnsafeBufferPointer(start: &tmp.0, count: MemoryLayout.size(ofValue: tmp)))
    }

    secp256k1_context_destroy(ctx)
    return Data(csigArray)
}


public func verifySawtoothSigning(signature: String, data: [UInt8], publicKey: [UInt8]) throws-> Bool {
    let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_VERIFY))

    var sig = secp256k1_ecdsa_signature()
    if secp256k1_ecdsa_signature_parse_compact(ctx!, &sig, signature.signertoBytes) == 0 {
        secp256k1_context_destroy(ctx)
        throw SigningError.invalidSignature
    }

    var pubKey = secp256k1_pubkey()
    let resultParsePublicKey = secp256k1_ec_pubkey_parse(ctx!, &pubKey, publicKey,
                                                         publicKey.count)
    if resultParsePublicKey == 0 {
        throw SigningError.invalidPublicKey
    }

    let msgDigest = signerHash(data: data)
    let result = msgDigest.withUnsafeBytes { (msgDigestBytes) -> Int32 in
        return secp256k1_ecdsa_verify(ctx!, &sig, msgDigestBytes, &pubKey)
    }

    secp256k1_context_destroy(ctx)

    if result == 1 {
        return true
    } else {
        return false
    }
}


extension UInt8 {
    static func signerfromHex(hexString: String) -> UInt8 {
        return UInt8(strtoul(hexString, nil, 16))
    }
}

extension StringProtocol {
    var signertoBytes: [UInt8] {
        let hexa = Array(self)
        return stride(from: 0, to: count, by: 2).compactMap {
            UInt8.signerfromHex(hexString: String(hexa[$0..<$0.advanced(by: 2)]))
        }
    }
}

public func signerHash(data: [UInt8]) -> Data {
    var digest = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
    _ = digest.withUnsafeMutableBytes { (digestBytes) in
        CC_SHA256(data, CC_LONG(data.count), digestBytes)
    }
    return digest
}
