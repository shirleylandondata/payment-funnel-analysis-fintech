# Data Dictionary

**Dataset:** Fintech payment funnel orders (synthetic)
**File:** `fintech_payment_funnel_orders.csv` (tab-delimited)
**Rows:** 5,000 (one row per order) · **Date range:** Jan 1, 2024 – Apr 30, 2025

## Order fields

| Field | Type | Description |
|---|---|---|
| order_id | ID | Unique order identifier |
| product_id | ID | Product purchased (joins to `fintech_payment_products.csv`) |
| customer_id | ID | Customer identifier |
| price | Number | Unit price |
| quantity | Number | Units ordered |
| discount_amount | Number | Discount applied |
| tax_amount | Number | Tax charged |
| order_total | Number | Order value after discount and tax, in the order's currency |
| order_date | Date | Date the order was placed |
| shipping_date | Date | Ship date (blank if not shipped) |
| currency | Text | USD, CAD, EUR, or GBP |

## Funnel fields

| Field | Type | Description |
|---|---|---|
| checkout_started_at | Timestamp | Checkout start |
| payment_method_entered_at | Timestamp | Payment method entered |
| payment_attempted_at | Timestamp | Payment submitted |
| payment_authorized_at | Timestamp | Payment authorized |
| payment_captured_at | Timestamp | Payment captured |
| payment_stage | Text | Furthest stage reached: `checkout_started`, `payment_method_entered`, `payment_attempted`, `payment_authorized`, `payment_captured` |
| payment_status | Text | Final status: Paid, Abandoned, Failed, Pending, Refunded, Chargeback |

## Payment and risk fields

| Field | Type | Description |
|---|---|---|
| payment_method | Text | Card, Digital Wallet, ACH, Bank Transfer, BNPL, Wire |
| payment_attempts | Number | Number of payment attempts (1–5) |
| requires_3ds_authentication | Flag | 1 if 3D Secure authentication was required |
| authentication_success | Flag | 1 if authentication passed (blank if not required) |
| gateway_response | Text | Gateway result code (e.g., `approved`, `card_declined`, `processor_error`) |
| decline_reason | Text | Reason for a failed payment (e.g., Card declined, AVS mismatch) |
| fraud_score | Number | Risk score (0.1–81.8) |
| fraud_flag | Flag | 1 if flagged as potential fraud |
| transaction_fee | Number | Processing fee |
| net_revenue | Number | Revenue recorded after fees |

## Context fields

| Field | Type | Description |
|---|---|---|
| checkout_device | Text | Desktop, Mobile, Tablet |
| traffic_source | Text | Direct, Email Campaign, Organic Search, Paid Search, Partner Marketplace, Referral, Social |
| customer_segment | Text | Enterprise, Mid-Market, SMB, Startup |
| region | Text | Midwest, Northeast, Southeast, Southwest, West, International |
| merchant_industry | Text | Merchant's industry (e.g., Retail, SaaS, Travel) |

**Companion file:** `fintech_payment_products.csv` lists 20 products (name, category, billing model, risk tier, list price).
