(use-modules (chickadee graphics light)
             (chickadee graphics model)
             (chickadee graphics mesh)
             (chickadee graphics buffer)
             (chickadee graphics phong)
             (chickadee graphics pbr)
             (chickadee math vector)
             (srfi srfi-9)
             (ice-9 match)
             (ice-9 ports)
             (ice-9 match)
             (ice-9 rdelim)
             (ice-9 receive)
             (rnrs bytevectors)
             (srfi srfi-1)
             (srfi srfi-9)
             (srfi srfi-27)
             (chickadee graphics skybox))

(define polyhedra-names
  '(( "r01"  "Tetrahedron " )
    ( "r02"  "Octahedron " )
    ( "r03"  "Cube " )
    ( "r04"  "Dodecahedron " )
    ( "r05"  "Icosahedron " )
    ( "s01"  "Cuboctahedron " )
    ( "s02"  "Icosidodeca-hedron " )
    ( "s03"  "Truncated tetrahedron " )
    ( "s04"  "Truncated octahedron " )
    ( "s05"  "Truncated cube " )
    ( "s06"  "Truncated icosahedron " )
    ( "s07"  "Truncated dodecahedron " )
    ( "s08"  "Rhombicuboctahedron " )
    ( "s09"  "Rhombicosidodecahedron " )
    ( "s10"  "Truncated cuboctahedron " )
    ( "s11"  "Truncated icosidodeca-hedron " )
    ( "s12L"  "Left Snub cube " )
    ( "s12R"  "Right Snub cube " )
    ( "s13L"  "Left Snub dodeca-hedron " )
    ( "s13R"  "Right Snub dodeca-hedron " )
    ( "n01"  "Square pyramid " )
    ( "n02"  "Pentagonal pyramid " )
    ( "n03"  "Triangular cupola " )
    ( "n04"  "Square cupola " )
    ( "n05"  "Pentagonal cupola " )
    ( "n06"  "Pentagonal rotunda " )
    ( "n07"  "Elongated triangular pyramid " )
    ( "n08"  "Elongated square pyramid " )
    ( "n09"  "Elongated pentagonal pyramid " )
    ( "n10"  "Gyro-elongated square pyramid " )
    ( "n11"  "Gyro-elongated pentagonal pyramid " )
    ( "n12"  "Triangular dipyramid " )
    ( "n13"  "Pentagonal dipyramid " )
    ( "n14"  "Elongated triangular dipyramid " )
    ( "n15"  "Elongated square dipyramid " )
    ( "n16"  "Elongated pentagonal dipyramid " )
    ( "n17"  "Gyro-elongated square dipyramid " )
    ( "n18"  "Elongated triangular cupola " )
    ( "n19"  "Elongated square cupola " )
    ( "n20"  "Elongated pentagonal cupola " )
    ( "n21"  "Elongated pentagonal rotunda " )
    ( "n22"  "Gylo-elongated triangular cupola " )
    ( "n23"  "Gylo-elongated square cupola " )
    ( "n24"  "Gylo-elongated pentagonal cupola " )
    ( "n25"  "Gylo-elongated pentagonal rotunda " )
    ( "n26"  "Gyrobifastigium " )
    ( "n27"  "Triangular ortho-bi-cupola " )
    ( "n28"  "Square ortho-bi-cupola " )
    ( "n29"  "Square gyro-bi-cupola " )
    ( "n30"  "Pentagonal ortho-bi-cupola " )
    ( "n31"  "Pentagonal gyro-bi-cupola " )
    ( "n32"  "Pentagonal ortho-cupola-rotunda " )
    ( "n33"  "Pentagonal gyro-cupola-rotunda " )
    ( "n34"  "Pentagonal ortho-bi-rotunda " )
    ( "n35"  "Elongated triangular ortho-bi-cupola " )
    ( "n36"  "Elongated triangular gyro-bi-cupola " )
    ( "n37"  "Elongated square gyro-bi-cupola " )
    ( "n38"  "Elongated pentagonal ortho-bi-cupola " )
    ( "n39"  "Elongated pentagonal gyro-bi-cupola " )
    ( "n40"  "Elongated pentagonal ortho-cupola-rotunda " )
    ( "n41"  "Elongated pentagonal gyro-cupola-rotunda " )
    ( "n42"  "Elongated pentagonal ortho-bi-rotunda " )
    ( "n43"  "Elongated pentagonal gyro-bi-rotunda " )
    ( "n44L"  "Left Gyro-elongated triangular bi-cupola " )
    ( "n44R"  "Right Gyro-elongated triangular bi-cupola " )
    ( "n45L"  "Left Gyro-elongated square bi-cupola " )
    ( "n45R"  "Right Gyro-elongated square bi-cupola " )
    ( "n46L"  "Left Gyro-elongated pentagonal bi-cupola " )
    ( "n46R"  "Right Gyro-elongated pentagonal bi-cupola " )
    ( "n47L"  "Left Gyro-elongated pentagonal cupola-rotunda " )
    ( "n47R"  "Right Gyro-elongated pentagonal cupola-rotunda " )
    ( "n48L"  "Left Gyro-elongated pentagonal bi-rotunda " )
    ( "n48R"  "Right Gyro-elongated pentagonal bi-rotunda " )
    ( "n49"  "Augmented triangular prism " )
    ( "n50"  "Bi-augmented triangular prism " )
    ( "n51"  "Tri-augmented triangular prism " )
    ( "n52"  "Augmented pentagonal prism " )
    ( "n53"  "Bi-augmented pentagonal prism " )
    ( "n54"  "Augmented hexagonal prism " )
    ( "n55"  "Para-bi-augmented hexagonal prism " )
    ( "n56"  "Meta-bi-augmented hexagonal prism " )
    ( "n57"  "Tri-augmented hexagonal prism " )
    ( "n58"  "Augmented dodeca-hedron " )
    ( "n59"  "Para-bi-augmented dodeca-hedron " )
    ( "n60"  "Meta-bi-augmented dodeca-hedron " )
    ( "n61"  "Tri-augmented dodeca-hedron " )
    ( "n62"  "Meta-bi-diminished icosahedron " )
    ( "n63"  "Tri-diminished icosahedron " )
    ( "n64"  "Augmented tridiminished icosahedron " )
    ( "n65"  "Augmented truncated tetrahedron " )
    ( "n66"  "Augmented truncated cube " )
    ( "n67"  "Augmented truncated cube " )
    ( "n68"  "Augmented truncated dodeca-hedron " )
    ( "n69"  "Para-bi-augmented truncated dodeca-hedron " )
    ( "n70"  "Meta-bi-augmented truncated dodeca-hedron " )
    ( "n71"  "Tri-augmented truncated dodeca-hedron " )
    ( "n72"  "Gyrate rhom-bi-cosi-dodeca-hedron " )
    ( "n73"  "Para-bi-gyrate rhom-bi-cosi-dodeca-hedron " )
    ( "n74"  "Meta-bi-gyrate rhom-bi-cosi-dodeca-hedron " )
    ( "n75"  "Tri-gyrate rhom-bi-cosi-dodeca-hedron " )
    ( "n76"  "Diminished rhom-bi-cosi-dodeca-hedron " )
    ( "n77"  "Para-gyrate diminished rhom-bi-cosi-dodeca-hedron " )
    ( "n78"  "Meta-gyrate diminished rhom-bi-cosi-dodeca-hedron " )
    ( "n79"  "Bi-gyrate diminished rhom-bi-cosi-dodeca-hedron " )
    ( "n80"  "Para-bi-gyrate diminished rhom-bi-cosi-dodeca-hedron " )
    ( "n81"  "Meta-bi-gyrate diminished rhom-bi-cosi-dodeca-hedron " )
    ( "n82"  "Gyrate bi-diminished rhom-bi-cosi-dodeca-hedron " )
    ( "n83"  "Tri-diminished rhom-bi-cosi-dodeca-hedron " )
    ( "n84"  "Snub disphenoid " )
    ( "n85"  "Snub square antiprism " )
    ( "n86"  "Spheno-corona " )
    ( "n87"  "Augmented spheno-corona " )
    ( "n88"  "Spheno-mega-corona " )
    ( "n89"  "Hebe-spheno-mega-corona " )
    ( "n90"  "Di-spheno-cingulum " )
    ( "n91"  "Bi-luna-bi-rotunda " )
    ( "n92"  "Triangular hebe-spheno-rotunda " )))

(define (random-material) (make-pbr-material #:base-color-factor (vec3 (random-real) (random-real) (random-real))))

(define red-material (make-pbr-material #:base-color-factor (vec3 1.0 0.1 0.1)))
(define blue-material (make-pbr-material #:base-color-factor (vec3 0.1 0.1 1.0)))
(define green-material (make-pbr-material #:base-color-factor (vec3 0.1 1.0 0.1)))

(define-record-type <vertex>
  (vertex position uv normal)
  vertex?
  (position vertex-position)
  (uv vertex-uv)
  (normal vertex-normal))

(define (build-mesh name vertices material)
  (let* ((index (make-hash-table))
         ;; Build index and count unique verts.
         (count
          (fold (lambda (vertex count)
                  (if (hashq-ref index vertex)
                      count
                      (begin
                        (hashq-set! index vertex count)
                        (+ count 1))))
                0
                vertices))
         ;; 8 floats per vertex.
         (stride (* 8 4))
         (verts (make-bytevector (* count stride)))
         (indices (make-u32vector (length vertices))))
    ;; Pack verts.
    (hash-for-each (lambda (vertex i)
                     (let ((p (vertex-position vertex))
                           (uv (vertex-uv vertex))
                           (n (vertex-normal vertex))
                           (offset (* i stride)))
                       (bytevector-ieee-single-native-set! verts offset
                                                           (vec3-x p))
                       (bytevector-ieee-single-native-set! verts (+ offset 4)
                                                           (vec3-y p))
                       (bytevector-ieee-single-native-set! verts (+ offset 8)
                                                           (vec3-z p))
                       (bytevector-ieee-single-native-set! verts (+ offset 12)
                                                           (vec2-x uv))
                       (bytevector-ieee-single-native-set! verts (+ offset 16)
                                                           (vec2-y uv))
                       (bytevector-ieee-single-native-set! verts (+ offset 20)
                                                           (vec3-x n))
                       (bytevector-ieee-single-native-set! verts (+ offset 24)
                                                           (vec3-y n))
                       (bytevector-ieee-single-native-set! verts (+ offset 28)
                                                           (vec3-z n))))
                   index)
    ;; Pack indices.
    (let loop ((i 0)
               (vertices vertices))
      (match vertices
        (() #t)
        ((vertex . rest)
         (u32vector-set! indices i (hashq-ref index vertex))
         (loop (+ i 1) rest))))
    (let* ((vertex-buffer (make-buffer verts #:stride stride))
           (index-buffer (make-buffer indices #:target 'index))
           (positions (make-vertex-attribute #:buffer vertex-buffer
                                             #:type 'vec3
                                             #:component-type 'float))
           (uvs (make-vertex-attribute #:buffer vertex-buffer
                                       #:offset 12
                                       #:type 'vec2
                                       #:component-type 'float))
           (normals (make-vertex-attribute #:buffer vertex-buffer
                                           #:offset 20
                                           #:type 'vec3
                                           #:component-type 'float))
           (vertex-array
            (make-vertex-array #:indices
                               (make-vertex-attribute #:buffer index-buffer
                                                      #:type 'scalar
                                                      #:component-type 'unsigned-int)
                               #:attributes `((0 . ,positions)
                                              (1 . ,uvs)
                                              (2 . ,normals))
                               #:mode 'triangle-fan)))
      (make-mesh name (list (make-primitive name vertex-array material))))))

(define (read-n-lines f n)
  (if (> n 0) (cons (read-line f) (read-n-lines f (1- n))) '()))

(define (read-all-lines f)
  (let ((nl (read-line f)))
    (if (eof-object? nl)
        '()
        (cons nl (read-all-lines f)))))

(define-record-type <kobayasi>
  (make-kobayasi adjacent adjacent-faces faces points)
  kobayasi?
  (adjacent kobayasi-adjacent)
  (adjacent-faces kobayasi-adjacent-faces)
  (faces kobayasi-faces)
  (points kobayasi-points))


(define (parse-pvec lne cnt)
  (letrec* ((lst (string-tokenize lne))
            (nums (map (compose string->number string-trim-both   ) lst)))
    (if (= cnt (car nums))
        `(,cnt . ,(cdr nums))
        (error "parsing error -- initial digit does not match position"))))

(define (parse-poly-stanza lns)
  (letrec* ((l (string->number (string-trim-both (car lns))))
            (elems (list-head (cdr lns) l)))
    (values (map parse-pvec elems (iota l 1))
            (list-tail lns (1+ l)))))

;; ooh it's a bit monadic
(define (parse-poly lns)
  (receive (adjacent-vertices r1) (parse-poly-stanza lns)
    (receive (adjacent-faces r2) (parse-poly-stanza r1)
      (receive (face-vertices r3) (parse-poly-stanza r2)
        (receive (point-vertices r4) (parse-poly-stanza r3)
          (make-kobayasi adjacent-vertices adjacent-faces face-vertices point-vertices))))))

(define (kk s) (parse-poly (read-all-lines (open-input-file (string-append "./polyhedron/data/" s)))))

(define k-a04 (kk "a04"))

(define (point->vertex x y z)
  (vertex (vec3 x y z) (vec2 0.0 1.0) (vec3 0.0 -1.0 0.0)))

(define (point-index->vertex k p)
  (apply point->vertex (assq-ref (kobayasi-points k) p)))

(define (make-a-plane k pts)
  (build-mesh "planey"
              (map (lambda (t) (point-index->vertex k t)) pts)
              (make-pbr-material)))

(define (make-a-face k idx)
  (build-mesh "facey"
              (map (lambda (t) (point-index->vertex k t)) (list-tail (list-ref (kobayasi-faces k) idx) 2))
              (random-material)))

(define (make-a-polyhedra s)
  (let* ((k (kk s))
        (num-faces (length (kobayasi-faces k))))
    (map (lambda (x) (make-a-face k x)) (iota num-faces))))


(define camera-position (vec3 0.0 0.0 2.0))
(define world (make-identity-matrix4))
(define view (look-at camera-position (vec3 0.0 0.0 0.0) (vec3 0.0 1.0 0.0)))
(define projection (perspective-projection (/ pi 3.0) (/ 4.0 3.0) 0.1 5.0))
(define skybox
  (make-skybox
   (load-cube-map #:right "./skyboxsun5deg/skyrender0001.bmp"
                  #:left "./skyboxsun5deg/skyrender0002.bmp"
                  #:top "./skyboxsun5deg/skyrender0003.bmp"
                  #:bottom  "./skyboxsun5deg/skyrender0004.bmp"
                  #:front "./skyboxsun5deg/skyrender0005.bmp"
                  #:back "./skyboxsun5deg/skyrender0001.bmp" )))


(define rotated (matrix4* (matrix4-rotate-x 0.7) (matrix4-rotate-y 0.1) (make-identity-matrix4)))

(define (rotate-now e) (let ((factor (modulo (round (* e 10)) 100))) (matrix4* (matrix4-rotate-x (/ factor 10)) (matrix4-rotate-y (/ factor 20)) (make-identity-matrix4))))

(define red-material (make-pbr-material #:base-color-factor (vec3 1.0 0.1 0.1)))
(define blue-material (make-pbr-material #:base-color-factor (vec3 0.1 0.1 1.0)))
(define green-material (make-pbr-material #:base-color-factor (vec3 0.1 1.0 0.1)))

(define cubey (make-cube 0.75 blue-material))
(define spherey (make-sphere 0.5 red-material))
(define dodecy (make-a-polyhedra "n59"))
(define dodecy-name "Para-bi-augmented dodeca-hedron " )

(set! *random-state* (random-state-from-platform))

(define (pick-a-poly)
  (let* ((r (random (length polyhedra-names)))
         (p (list-ref polyhedra-names r)))
  p))


(define todays-poly (pick-a-poly))
(define dodecy (make-a-polyhedra (car todays-poly)))
(define dodecy-name (cadr todays-poly))

(define (draw alpha)
  (with-projection projection
                   (draw-skybox skybox view)
                   (map (lambda (x) (draw-mesh x
                                               #:model-matrix (rotate-now (elapsed-time))
                                               #:view-matrix view
                                               #:camera-position camera-position
                                               #:skybox skybox)) dodecy))
  (draw-text dodecy-name (vec2 30.0 30.0)))

(define (mouse-release a x y)
  (set! todays-poly (pick-a-poly))
  (set! dodecy (make-a-polyhedra (car todays-poly)))
  (set! dodecy-name (cadr todays-poly)))
