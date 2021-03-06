;; This script renders a PNG of the screen graph.
;; TODO: Update README to include how to do this

;; Create dot-file compatible names
(defun dot-name (node)
       (substitute-if #\_ (complement #'alphanumericp) (prin1-to-string node)))

;; Create labels for dot. Max-length 30
(defparameter *max-label-length* 30)

(defun dot-label (node)
     (if node
                (let ((stringd (prin1-to-string node)))
	        (cond ((> (length stringd) *max-label-length*) (concatenate 'string (subseq stringd 0 (- *max-label-length* 3)) "..."))
			      (t stringd)))
				  ""))



;; Convert nodes to dot format
(defun nodes->dot (nodes)

	         (mapc (lambda (node)
			               (fresh-line)
				   		   (princ (dot-name (car node)))
				           (princ "[label=")
				           (princ (dot-label (cdr node)))
				           (princ "]"))
				    nodes))

;; Convert edges to dot format
(defun edges->dot (edges)
       (mapc (lambda (node)
	                 (mapc  (lambda (edge)
      			                    (fresh-line)
			                        (princ (car node))
					                (princ "->")
					                (princ (car edge)))
					        (cdr node)))
			 edges))



;; Combine the above two:  nodes and edges to dot format
(defun graph->dot (edges nodes)
                  (princ "digraph {")
				  (nodes->dot nodes)
				  (edges->dot edges)
				  (princ "}"))

;; Write to file and execute graphviz to create png
(defun dot->png (fname thunk)
                (with-open-file (*standard-output* fname :direction :output :if-exists :supersede)
				                (funcall thunk))
				(ext:shell (concatenate 'string "dot -Tpng -0 " fname)))

;; Final function to convert graph to png
(defun graph->png (fname nodes edges)
                  (dot->png fname
				           (lambda () (graph->dot nodes edges))
				  ))
