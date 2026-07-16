# Join Me 揪ㄇ Website

Join Me 揪ㄇ的產品宣傳網站，包含：

- 產品理念與核心功能介紹
- 測試名單 Email 表單
- Support 表單
- Privacy Policy
- Terms of Service

## 本機執行

```bash
cd website
npm run dev
```

開啟 <http://127.0.0.1:4173>。

## 表單資料

本機收到的測試名單與 Support 訊息會分別寫入：

- `data/waitlist.ndjson`
- `data/support.ndjson`

這兩個檔案已被 `.gitignore` 排除，不會提交到版本控制。
