iOS 端椭圆曲线 Secp256k1 签名与验签的实现

## 安装
```ruby
pod 'Secp256k1Signing'
```

## 签名
```swift
let hexStr = "待签名的字符串信息"
/// 转换格式
let signStrArr = [UInt8](hexStr.utf8)

/// 调用
/// privateKeyStr.hexaBytes : 私钥的[Uint8]格式
do {
    ///  signData 验签时需要的数据
    let signData = try signSawtoothSigning(data: signStrArr, privateKey: privateKeyStr.hexaBytes)
    let signStr = signData.base64EncodedString()
    return signStr
    
} catch {
    return
}
```

## 验签
```swift
do {
    ///  返回结果为 BOOL 类型, true 为验签通过, false 验签失败
    let verify = try verifySawtoothSigning(signature: signData.hex, data: signStrArr, publicKey:privateKeyStr.hexaBytes)
} catch {
    return 
}
```

## 字符串转hexaBytes示例
```swift
extension StringProtocol {
    internal var hexaData: Data { .init(hexa) }
    internal var hexaBytes: [UInt8] { .init(hexa) }
    private var hexa: UnfoldSequence<UInt8, Index> {
        sequence(state: startIndex) { start in
            guard start < self.endIndex else { return nil }
            let end = self.index(start, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { start = end }
            return UInt8(self[start..<end], radix: 16)
        }
    }
}
```
