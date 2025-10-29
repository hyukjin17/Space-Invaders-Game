;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname Space_Invaders) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; An Invader is a Posn
; INTERP: represents the location of the invader
 
; A Bullet is a Posn
; INTERP: represents the location of a bullet
 
; A Location is a Posn
; INTERP: represents a location of a spaceship

;; Posn -> ?
(define (posn-temp p)
  (... (posn-x p) (posn-y p) ...))
 
; A Direction is one of:
; - "left"
; - "right"
; INTERP: represent direction of movement for the spaceship
 
(define-struct ship (dir loc))
; A Ship is (make-ship Direction Location)
; INTERP: represent the spaceship with its current direction
;         and movement

;; Ship -> ?
(define (ship-temp s)
  (... (ship-dir s) (posn-temp (ship-loc s)) ...))
 
; A List of Invaders (LoI) is one of
; - '()
; - (cons Invader LoI)

;; LoI -> ?
(define (loi-temp aloi)
  (cond
    [(empty? aloi) ...]
    [(cons? aloi) (... (posn-temp (first aloi)) (loi-temp (rest aloi)) ...)]))
 
; A List of Bullets (LoB) is one of
; - '()
; - (cons Bullet LoB)

;; LoB -> ?
(define (lob-temp alob)
  (cond
    [(empty? alob) ...]
    [(cons? alob) (... (posn-temp (first alob)) (lob-temp (rest alob)) ...)]))


;; LoB LoI -> ?
(define (two-lists-temp l1 l2)
  (cond [(and (empty? l1)(empty? l2)) ...]
        [(and (empty? l1)(cons? l2)) (...(first l2)..(rest l2))]
        [(and (cons? l1) (empty? l2)) (...(first l1)...(rest l1))]
        [(and (cons? l1) (cons? l2)) (...(first l1)
                                         ...(first l2)
                                         ...(two-lists-temp (rest l1)
                                                            (rest l2)))]))

 
(define-struct world (ship invaders ship-bullets invader-bullets))
; A World is (make-world Ship LoI LoB LoB)
; INTERP: represent the ship, the current list of invaders, the inflight spaceship bullets
;         and the inflight invader bullets

;; World -> ?
(define (world-temp w)
  (... (ship-temp (world-ship w))
       (loi-temp (world-invaders w))
       (lob-temp (world-ship-bullets w))
       (lob-temp (world-invader-bullets w)) ...))


(define WIDTH 500)
(define HEIGHT 500)
(define MAX-SHIP-BULLETS 3)
(define MAX-INVADER-BULLETS 10)
(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define SPACESHIP-BULLET-IMAGE (circle 2 'solid 'black))
(define SHIP-WIDTH 25)
(define SHIP-HEIGHT 15)
(define SPACESHIP-IMAGE (rectangle SHIP-WIDTH SHIP-HEIGHT 'solid 'black))
(define INVADER-SIDE 20)
(define INVADER-IMAGE (square INVADER-SIDE 'solid 'red))
(define INVADER-BULLET-IMAGE (circle 2 'solid 'red))
(define SHIP-SPEED 10)
(define BULLET-SPEED 10)
(define SHIP-INIT (make-ship "left" (make-posn 250 480)))
(define INVADERS-INIT
  (list (make-posn 100 20) (make-posn 140 20) (make-posn 180 20)
        (make-posn 220 20) (make-posn 260 20) (make-posn 300 20)
        (make-posn 340 20) (make-posn 380 20) (make-posn 420 20)
        (make-posn 100 50) (make-posn 140 50) (make-posn 180 50)
        (make-posn 220 50) (make-posn 260 50) (make-posn 300 50)
        (make-posn 340 50) (make-posn 380 50) (make-posn 420 50)
        (make-posn 100 80) (make-posn 140 80) (make-posn 180 80)
        (make-posn 220 80) (make-posn 260 80) (make-posn 300 80)
        (make-posn 340 80) (make-posn 380 80) (make-posn 420 80)
        (make-posn 100 110) (make-posn 140 110) (make-posn 180 110)
        (make-posn 220 110) (make-posn 260 110) (make-posn 300 110)
        (make-posn 340 110) (make-posn 380 110) (make-posn 420 110)))
(define WORLD-INIT (make-world SHIP-INIT INVADERS-INIT empty empty))



;; Examples:
(define ship1 (make-ship "right" (make-posn 250 450)))
(define invader1 (cons (make-posn 120 180) '()))
(define ship-bullets1 (cons (make-posn 100 400) '()))
(define invader-bullets1 (cons (make-posn 120 250) '()))
(define world0 (make-world ship1 invader1 empty empty))
(define world1 (make-world ship1 invader1 ship-bullets1 invader-bullets1))

(define ship2 (make-ship "left" (make-posn 300 480)))
(define invader2 (list (make-posn 100 20) (make-posn 140 20) (make-posn 180 20)))
(define ship-bullets2 (list (make-posn 100 400) (make-posn 200 200) (make-posn 250 400)))
(define invader-bullets2 (list (make-posn 100 300) (make-posn 140 250) (make-posn 180 100)))
(define world2 (make-world ship2 invader2 ship-bullets2 invader-bullets2))
(define world3 (make-world ship2 invader2
                           (list (make-posn 100 400) (make-posn 110 30) (make-posn 200 700))
                           (list (make-posn 100 300) (make-posn 140 250) (make-posn 180 600))))
(define ship3 (make-ship "left" (make-posn 10 480)))
(define ship4 (make-ship "right" (make-posn 490 480)))


; game: World -> World
; launches the game
(define (game w)
  (big-bang w
    [to-draw world-draw]
    [on-tick update-world 0.1]
    [on-key turn-and-shoot]
    [stop-when end? endscreen]))

; world-draw : World -> Image
; draws the entire World with spaceship bullets, invader bullets,
;                             invaders, and the ship on the background
(check-expect (world-draw world0)
              (place-image SPACESHIP-IMAGE 250 450
                           (place-image
                            INVADER-IMAGE 120 180 BACKGROUND)))
(check-expect (world-draw world1)
              (place-image INVADER-BULLET-IMAGE 120 250
                           (place-image SPACESHIP-BULLET-IMAGE 100 400
                                        (place-image SPACESHIP-IMAGE 250 450
                                                     (place-image
                                                      INVADER-IMAGE 120 180 BACKGROUND)))))
(check-expect (world-draw world2)
              (place-image
               INVADER-BULLET-IMAGE 100 300
               (place-image
                INVADER-BULLET-IMAGE 140 250
                (place-image
                 INVADER-BULLET-IMAGE 180 100
                 (place-image
                  SPACESHIP-BULLET-IMAGE 100 400
                  (place-image
                   SPACESHIP-BULLET-IMAGE 200 200
                   (place-image
                    SPACESHIP-BULLET-IMAGE 250 400
                    (place-image
                     SPACESHIP-IMAGE 300 480
                     (place-image
                      INVADER-IMAGE 100 20
                      (place-image
                       INVADER-IMAGE 140 20
                       (place-image
                        INVADER-IMAGE 180 20 BACKGROUND)))))))))))
(define (world-draw w)
  (draw-invader-bullets (world-invader-bullets w)
                        (draw-ship-bullets
                         (world-ship-bullets w)
                         (draw-ship (world-ship w)
                                    (draw-invaders (world-invaders w))))))

; draw-invader-bullets : LoB Image -> Image
; draws invader bullets onto the scene (draw-ship-bullets)
(check-expect (draw-invader-bullets '() BACKGROUND) BACKGROUND)
(check-expect (draw-invader-bullets invader-bullets1 BACKGROUND)
              (place-image INVADER-BULLET-IMAGE 120 250 BACKGROUND))
(check-expect (draw-invader-bullets invader-bullets2 BACKGROUND)
              (place-image INVADER-BULLET-IMAGE 100 300
                           (place-image INVADER-BULLET-IMAGE 140 250
                                        (place-image INVADER-BULLET-IMAGE 180 100 BACKGROUND))))
(check-expect
 (draw-invader-bullets invader-bullets1
                       (draw-ship-bullets ship-bullets1
                                          (draw-ship ship1
                                                     (draw-invaders (world-invaders world1)))))
 (place-image INVADER-BULLET-IMAGE 120 250
              (place-image SPACESHIP-BULLET-IMAGE 100 400
                           (place-image SPACESHIP-IMAGE 250 450
                                        (place-image INVADER-IMAGE 120 180 BACKGROUND)))))
(define (draw-invader-bullets alob img)
  (cond
    [(empty? alob) img]
    [(cons? alob)
     (place-image INVADER-BULLET-IMAGE
                  (posn-x (first alob))
                  (posn-y (first alob))
                  (draw-invader-bullets (rest alob) img))]))

; draw-ship-bullets : LoB Image -> Image
; draws spaceship bullets onto the scene (draw-ship)
(check-expect (draw-ship-bullets '() BACKGROUND) BACKGROUND)
(check-expect (draw-ship-bullets ship-bullets1 BACKGROUND)
              (place-image SPACESHIP-BULLET-IMAGE 100 400 BACKGROUND))
(check-expect (draw-ship-bullets ship-bullets2 BACKGROUND)
              (place-image SPACESHIP-BULLET-IMAGE 100 400
                           (place-image SPACESHIP-BULLET-IMAGE 200 200
                                        (place-image SPACESHIP-BULLET-IMAGE 250 400 BACKGROUND))))
(check-expect (draw-ship-bullets ship-bullets1
                                 (draw-ship ship1 (draw-invaders (world-invaders world1))))
              (place-image SPACESHIP-BULLET-IMAGE 100 400
                           (place-image SPACESHIP-IMAGE 250 450
                                        (place-image INVADER-IMAGE 120 180 BACKGROUND))))
(define (draw-ship-bullets alob img)
  (cond
    [(empty? alob) img]
    [(cons? alob)
     (place-image SPACESHIP-BULLET-IMAGE
                  (posn-x (first alob))
                  (posn-y (first alob))
                  (draw-ship-bullets (rest alob) img))]))

; draw-ship : Ship Image -> Image
; draws the Ship onto the scene with Invaders
(check-expect (draw-ship ship1 BACKGROUND)
              (place-image SPACESHIP-IMAGE 250 450 BACKGROUND))
(check-expect (draw-ship ship2 BACKGROUND)
              (place-image SPACESHIP-IMAGE 300 480 BACKGROUND))
(check-expect (draw-ship ship1 (draw-invaders (world-invaders world1)))
              (place-image SPACESHIP-IMAGE 250 450 (place-image INVADER-IMAGE 120 180 BACKGROUND)))
(define (draw-ship s img)
  (place-image SPACESHIP-IMAGE (ship-x-pos s) (ship-y-pos s) img))

;; ship-x-pos: Ship -> Number
;; outputs the x-position of the Ship
(check-expect (ship-x-pos ship1) 250)
(check-expect (ship-x-pos ship2) 300)
(define (ship-x-pos s)
  (posn-x (ship-loc s)))

;; ship-y-pos: Ship -> Number
;; outputs the y-position of the Ship
(check-expect (ship-y-pos ship1) 450)
(check-expect (ship-y-pos ship2) 480)
(define (ship-y-pos s)
  (posn-y (ship-loc s)))

;; draw-invaders: LoI -> Image
;; draws the grid of Invaders on an empty scene
(check-expect (draw-invaders '()) BACKGROUND)
(check-expect (draw-invaders invader1)
              (place-image INVADER-IMAGE 120 180 BACKGROUND))
(check-expect (draw-invaders invader2)
              (place-image INVADER-IMAGE 100 20
                           (place-image INVADER-IMAGE 140 20
                                        (place-image INVADER-IMAGE 180 20 BACKGROUND))))
(define (draw-invaders aloi)
  (cond
    [(empty? aloi) BACKGROUND]
    [(cons? aloi) (place-image INVADER-IMAGE
                               (posn-x (first aloi))
                               (posn-y (first aloi))
                               (draw-invaders (rest aloi)))]))




; update-world: World -> World
; moves the world, removes invaders that have been hit and removes bullets that are out of bounds
(check-expect (world-ship (update-world world0))
              (make-ship "right" (make-posn 260 450)))
(check-expect (world-ship-bullets(update-world world1))
              (cons (make-posn 100 390) '()))
(check-expect (world-invaders (update-world world0)) invader1)
(define (update-world w)
  (remove-hits-and-out-of-bounds (move-world w)))

; remove-hits-and-out-of-bounds: World -> World
; remove any invaders that have been hit by a spaceship bullet and any bullets that are out of bounds
(check-expect (remove-hits-and-out-of-bounds world0) world0)
(check-expect (remove-hits-and-out-of-bounds world1) world1)
(check-expect (remove-hits-and-out-of-bounds world3)
              (make-world ship2
                          (list (make-posn 140 20) (make-posn 180 20))
                          (list (make-posn 100 400))
                          (list (make-posn 100 300) (make-posn 140 250))))
(define (remove-hits-and-out-of-bounds w)
  (make-world (world-ship w)
              (remove-invader (world-invaders w) (world-ship-bullets w))
              (remove-ship-bullets (world-ship-bullets w) (world-invaders w))
              (remove-invader-bullets (world-invader-bullets w))))

; remove-invader: LoI LoB -> LoI
; removes the invaders that are hit by bullets
(check-expect (remove-invader '() ship-bullets1) '())
(check-expect (remove-invader invader1 '()) invader1)
(check-expect (remove-invader invader1 ship-bullets1) invader1)
(check-expect (remove-invader invader2
                              (list (make-posn 100 400) (make-posn 110 30) (make-posn 200 700)))
              (list (make-posn 140 20) (make-posn 180 20)))
(define (remove-invader aloi alob)
  (cond [(or (empty? alob) (empty? aloi)) aloi]
        [(and (cons? alob) (cons? aloi)) (if (bullets-hit? (first aloi) alob)
                                             (remove-invader (rest aloi) alob)
                                             (cons (first aloi)
                                                   (remove-invader (rest aloi) alob)))]))

; bullets-hit?: Invader LoB -> Boolean
; true if an invader has been hit by any bullet, false otherwise
(check-expect (bullets-hit? invader1 '()) #false)
(check-expect (bullets-hit? (make-posn 20 20) ship-bullets1) #false)
(check-expect (bullets-hit? (make-posn 100 400) ship-bullets2) #true)
(define (bullets-hit? i alob)
  (cond
    [(empty? alob) #false]
    [(cons? alob) (if (invader-hit? (first alob) i) #true
                      (bullets-hit? i (rest alob)))]))

; invader-hit?: Bullet Invader -> Boolean
; true if an invader has been hit by a bullet, false otherwise
(check-expect (invader-hit? (make-posn 30 40) (make-posn 30 40)) #true)
(check-expect (invader-hit? (make-posn 40 50) (make-posn 30 40)) #true)
(check-expect (invader-hit? (make-posn 10 10) (make-posn 20 50)) #false)
(define (invader-hit? abullet i)
  (and (<= (- (posn-x i) (/ INVADER-SIDE 2)) (posn-x abullet) (+ (posn-x i) (/ INVADER-SIDE 2)))
       (<= (- (posn-y i) (/ INVADER-SIDE 2)) (posn-y abullet) (+ (posn-y i) (/ INVADER-SIDE 2)))))

; remove-ship-bullets: LoB LoI -> LoB
; removes the spaceship bullets if they go out of bounds or hit an invader
(check-expect (remove-ship-bullets '() '()) '())
(check-expect (remove-ship-bullets ship-bullets1 invader1) ship-bullets1)
(check-expect (remove-ship-bullets ship-bullets1 (list (make-posn 100 400) (make-posn 10 10))) '())
(define (remove-ship-bullets alob aloi)
  (cond [(or (empty? alob) (empty? aloi)) alob]
        [(and (cons? alob) (cons? aloi)) (if (or (invaders-hit? (first alob) aloi)
                                                 (out-of-bounds? (first alob)))
                                             (remove-ship-bullets (rest alob) aloi)
                                             (cons (first alob)
                                                   (remove-ship-bullets (rest alob) aloi)))]))

; invaders-hit?: Bullet LoI -> Boolean
; true if any invader has been hit by a bullet, false otherwise
(check-expect (invaders-hit? (make-posn 10 10) '()) #false)
(check-expect (invaders-hit? (make-posn 130 190) invader1) #true)
(check-expect (invaders-hit? (make-posn 30 40) invader1) #false)
(define (invaders-hit? abullet aloi)
  (cond
    [(empty? aloi) #false]
    [(cons? aloi) (if (invader-hit? abullet (first aloi)) #true
                      (invaders-hit? abullet (rest aloi)))]))

; out-of-bounds?: Bullet -> Boolean
; returns true if the bullet is out of bounds in the y-direction and false otherwise
(check-expect (out-of-bounds? (make-posn 10 10)) #false)
(check-expect (out-of-bounds? (make-posn 19 -3)) #true)
(check-expect (out-of-bounds? (make-posn 19 -2)) #false)
(check-expect (out-of-bounds? (make-posn 30  508)) #true)
(define (out-of-bounds? abullet)
  (not (<= (- 0 (/ (image-height SPACESHIP-BULLET-IMAGE) 2))
           (posn-y abullet)
           (+ HEIGHT (/ (image-height SPACESHIP-BULLET-IMAGE) 2)))))

; remove-invader-bullets: LoB -> LoB
; removes the invader bullets if they go out of bounds
(check-expect (remove-invader-bullets '()) '())
(check-expect (remove-invader-bullets invader-bullets1) invader-bullets1)
(check-expect (remove-invader-bullets (list (make-posn 20 500) (make-posn 50 50)))
              (list (make-posn 20 500) (make-posn 50 50)))
(check-expect (remove-invader-bullets (list (make-posn 20 503) (make-posn 50 50)))
              (list (make-posn 50 50)))
(check-expect (remove-invader-bullets (list (make-posn 20 503) (make-posn 50 -10))) '())
(define (remove-invader-bullets alob)
  (cond [(empty? alob) alob]
        [(cons? alob) (if (out-of-bounds? (first alob))
                          (remove-invader-bullets (rest alob))
                          (cons (first alob)
                                (remove-invader-bullets (rest alob))))]))




; move-world: World -> World
; moves the spaceship and all the bullets by their respective SPEED
(check-expect (world-ship (move-world world0))
              (make-ship "right" (make-posn 260 450)))
(check-expect (world-ship-bullets(move-world world1))
              (cons (make-posn 100 390) '()))
(check-expect (world-invaders (move-world world0)) invader1)
(define (move-world w)
  (make-world (move-spaceship (world-ship w))
              (world-invaders w)
              (move-spaceship-bullets (world-ship-bullets w))
              (invaders-fire (move-invader-bullets (world-invader-bullets w))
                             (world-invaders w))))

; move-spaceship: Ship -> Ship
; moves the ship either left or right by SPEED units
(check-expect (move-spaceship ship1) (make-ship "right" (make-posn 260 450)))
(check-expect (move-spaceship ship2) (make-ship "left" (make-posn 290 480)))
(check-expect (move-spaceship ship3) ship3)
(check-expect (move-spaceship ship4) ship4)
(define (move-spaceship s)
  (cond
    [(and (string=? (ship-dir s) "left") (>= (ship-x-pos s) (/ SHIP-WIDTH 2)))
     (make-ship (ship-dir s) (move-x (ship-loc s) (* -1 SHIP-SPEED)))]
    [(and (string=? (ship-dir s) "right") (<= (ship-x-pos s) (- WIDTH (/ SHIP-WIDTH 2))))
     (make-ship (ship-dir s) (move-x (ship-loc s) SHIP-SPEED))]
    [else s]))

; move-x Location Number -> Location
; adds n units to the x-position of the Ship
(check-expect (move-x (make-posn 10 20) 20) (make-posn 30 20))
(check-expect (move-x (make-posn 50 40) -20) (make-posn 30 40))
(define (move-x l n)
  (make-posn (+ (posn-x l) n) (posn-y l)))

; move-spaceship-bullets : LoB -> LoB
; moves each spaceship bullet in the list upwards by SPEED units
(check-expect (move-spaceship-bullets '()) '())
(check-expect (move-spaceship-bullets ship-bullets1) (list (make-posn 100 390)))
(check-expect (move-spaceship-bullets ship-bullets2)
              (list (make-posn 100 390) (make-posn 200 190) (make-posn 250 390)))
(define (move-spaceship-bullets alob)
  (cond
    [(empty? alob) '()]
    [(cons? alob) (cons (move-bullet (first alob) (* -1 BULLET-SPEED))
                        (move-spaceship-bullets (rest alob)))]))

; move-invader-bullets : LoB -> LoB
; moves each invader bullet in the list downwards by SPEED units
(check-expect (move-invader-bullets '()) '())
(check-expect (move-invader-bullets invader-bullets1) (cons (make-posn 120 260) '()))
(check-expect (move-invader-bullets invader-bullets2)
              (list (make-posn 100 310) (make-posn 140 260) (make-posn 180 110)))
(define (move-invader-bullets alob)
  (cond
    [(empty? alob) '()]
    [(cons? alob) (cons (move-bullet (first alob) BULLET-SPEED)
                        (move-invader-bullets (rest alob)) )]))
 
; move-bullet: Bullet Number -> Bullet
; adds n units to the y-position of a Bullet
(check-expect (move-bullet (make-posn 100 400) BULLET-SPEED) (make-posn 100 410))
(check-expect (move-bullet (make-posn 200 150) (* -1 BULLET-SPEED)) (make-posn 200 140))
(define (move-bullet abullet n)
  (make-posn (posn-x abullet) (+ (posn-y abullet) n)))

; invaders-fire: LoB LoI -> LoB
; fire from a random invader to hit the ship
(check-expect (invaders-fire invader-bullets1 empty) invader-bullets1)
(check-expect (invaders-fire (list (make-posn 100 20) (make-posn 140 20) (make-posn 180 20)
                                   (make-posn 220 20) (make-posn 260 20) (make-posn 300 20)
                                   (make-posn 340 20) (make-posn 380 20) (make-posn 420 20)
                                   (make-posn 100 50) (make-posn 140 50) (make-posn 180 50))
                             INVADERS-INIT)
              (list (make-posn 100 20) (make-posn 140 20) (make-posn 180 20)
                    (make-posn 220 20) (make-posn 260 20) (make-posn 300 20)
                    (make-posn 340 20) (make-posn 380 20) (make-posn 420 20)
                    (make-posn 100 50) (make-posn 140 50) (make-posn 180 50)))
(define (invaders-fire alob aloi)
  (cond [(empty? aloi) alob]
        [(cons? aloi) (if (< (length alob) (random MAX-INVADER-BULLETS))
                          (cons (make-posn (posn-x (random-invader aloi))
                                           (posn-y (random-invader aloi))) alob)
                          alob)]))

; random-invader: LoI -> Invader
; returns a random invader from the list of invaders
(check-expect (random-invader invader1) (make-posn 120 180))
(check-random (random-invader invader2) (list-ref invader2 (random 3)))
(check-random (random-invader INVADERS-INIT) (list-ref INVADERS-INIT (random 36)))
(define (random-invader aloi)
  (list-ref aloi (random (length aloi))))




; turn-and-shoot: World KeyEvent -> World
; based on the KeyEvent, changes the direction of the ship or shoots spaceship bullets
(check-expect (turn-and-shoot world0 "left")
              (make-world (make-ship "left" (make-posn 250 450))
                          (cons (make-posn 120 180) '()) empty empty))
(check-expect (turn-and-shoot world0 "right")
              (make-world (make-ship "right" (make-posn 250 450))
                          (cons (make-posn 120 180) '()) empty empty))
(check-expect (turn-and-shoot world0 " ")
              (make-world (make-ship "right" (make-posn 250 450))
                          (cons (make-posn 120 180) '()) (cons (make-posn 250 450) '()) empty))
(check-expect (turn-and-shoot world1 " ")
              (make-world (make-ship "right" (make-posn 250 450))
                          (cons (make-posn 120 180) '())
                          (list (make-posn 250 450) (make-posn 100 400))
                          (cons (make-posn 120 250) '())))
(check-expect (turn-and-shoot world1 "r") world1)
(define (turn-and-shoot w ke)
  (cond [(or (string=? ke "right") (string=? ke "left"))
         (make-world (change-direction (world-ship w) ke)
                     (world-invaders w)
                     (world-ship-bullets w)
                     (world-invader-bullets w))]
        [(string=? ke " ")
         (make-world (world-ship w)
                     (world-invaders w)
                     (shoot (world-ship-bullets w) (world-ship w))
                     (world-invader-bullets w))]
        [else w]))

; change-direction: Ship KeyEvent -> Ship
; changes the direction of the ship based on key input
(check-expect (change-direction ship1 "left")
              (make-ship "left" (make-posn 250 450)))
(check-expect (change-direction ship1 "right")
              (make-ship "right" (make-posn 250 450)))
(check-expect (change-direction ship2 "right")
              (make-ship "right" (make-posn 300 480)))
(define (change-direction s ke)
  (make-ship ke (ship-loc s)))

; shoot: LoB Ship -> LoB
; creates a new spaceship bullet if there are less than 3 bullets on screen
(check-expect (shoot '() ship1) (cons (make-posn 250 450) '()))
(check-expect (shoot ship-bullets1 ship1) (list (make-posn 250 450) (make-posn 100 400)))
(check-expect (shoot ship-bullets2 ship1) ship-bullets2)
(define (shoot alob s)
  (if (< (length alob) MAX-SHIP-BULLETS)
      (cons (make-posn (ship-x-pos s) (ship-y-pos s)) alob)
      alob))




; end?: World -> Boolean
; returns true if the ship is hit or there are no more invaders left
(check-expect (end? world0) #false)
(check-expect (end? world1) #false)
(check-expect (end? world2) #false)
(check-expect (end? (make-world ship1 invader1 empty (list (make-posn 250 450)))) #true)
(check-expect (end? (make-world ship1 empty empty empty)) #true)
(define (end? w)
  (or (ship-hit? (world-ship w) (world-invader-bullets w))
      (empty? (world-invaders w))))


; endscreen: World -> Image
(check-expect (endscreen world0)
              (overlay (text "Game Over" 50 "green")
                       (world-draw world0)))
(check-expect (endscreen world1)
              (overlay (text "Game Over" 50 "green")
                       (world-draw world1)))
(define (endscreen w)
  (overlay (text "Game Over" 50 "green")
           (world-draw w)))


; ship-hit?: Ship LoB -> Boolean
; true if any bullet hits the ship, false otherwise
(check-expect (ship-hit? (make-ship "left" (make-posn 20 20))  '()) #false)
(check-expect (ship-hit? (make-ship "left" (make-posn 112.5 307.5)) invader-bullets2) #true)
(check-expect (ship-hit? (make-ship "left" (make-posn 113 307.5)) invader-bullets2) #false)
(check-expect (ship-hit? (make-ship "right" (make-posn 20 20)) invader-bullets2) #false)
(define (ship-hit? s alob)
  (cond
    [(empty? alob) #false]
    [(cons? alob) (if (bullet-hit-ship? (first alob) s) #true
                      (ship-hit? s (rest alob)))]))

; bullet-hit-ship?: Bullet Ship -> Boolean
; true if a given bullet hits the ship, false otherwise
(check-expect (bullet-hit-ship? (make-posn 32.5 27.5) (make-ship "left" (make-posn 20 20))) #true)
(check-expect (bullet-hit-ship? (make-posn 40 27.5) (make-ship "left" (make-posn 20 20))) #false)
(check-expect (bullet-hit-ship? (make-posn 20 20) (make-ship "right" (make-posn 100 300))) #false)
(define (bullet-hit-ship? abullet s)
  (and (<= (- (ship-x-pos s) (/ SHIP-WIDTH 2))
           (posn-x abullet)
           (+ (ship-x-pos s) (/ SHIP-WIDTH 2)))
       (<= (- (ship-y-pos s) (/ SHIP-HEIGHT 2))
           (posn-y abullet)
           (+ (ship-y-pos s) (/ SHIP-HEIGHT 2)))))


(game WORLD-INIT)