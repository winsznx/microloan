;; MicroLoan - P2P lending
(define-constant ERR-INSUFFICIENT-COLLATERAL (err u100))
(define-constant ERR-NOT-FOUND (err u101))

(define-map loans
    { loan-id: uint }
    { borrower: principal, lender: (optional principal), amount: uint, collateral: uint, due-date: uint, repaid: bool }
)

(define-data-var loan-counter uint u0)
(define-data-var collateral-ratio uint u150)

(define-public (request-loan (amount uint) (duration uint) (collateral uint))
    (let ((loan-id (var-get loan-counter)))
        (asserts! (>= collateral (* amount (var-get collateral-ratio))) ERR-INSUFFICIENT-COLLATERAL)
        (map-set loans { loan-id: loan-id } {
            borrower: tx-sender,
            lender: none,
            amount: amount,
            collateral: collateral,
            due-date: (+ block-height duration),
            repaid: false
        })
        (var-set loan-counter (+ loan-id u1))
        (ok loan-id)
    )
)

(define-read-only (get-loan (loan-id uint))
    (map-get? loans { loan-id: loan-id })
)
