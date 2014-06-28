## Matrix inversion is usually a costly computation and their may be some benefit to caching the inverse of a matrix
## rather than compute it repeatedly (there are also alternatives to matrix inversion that we will not discuss here).
## The purpose of this assignment is to write a pair of functions that cache the inverse of a matrix.

## The purpose of the function 'makeCacheMatrix' is to create a special "matrix" object that can cache its inverse.

makeCacheMatrix <- function(x = matrix()) {
        inverse_x <- NULL
        set <- function(y) {
                x <<- y
                inverse_x <<- NULL
        }
        get <- function() x
        setinverse <- function(inverse) inv_x <<- inverse
        getinverse <- function() inverse_x
        list(set = set, get = get,
             setinverse = setinverse,
             getinverse = getinverse)
}


## The purpose of the function 'cacheSolve' is to compute the inverse of the special "matrix" returned by makeCacheMatrix above.
## If the inverse has already been calculated (and the matrix has not changed), then the cachesolve should retrieve the
## inverse from the cache.

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
        inverse_x <- x$getinverse()
        if (!is.null(inverse_x)) {
                message("Getting Cached Inverse Matrix")
                return(inverse_x)
        } else {
                inverse_x <- solve(x$get())
                x$setinverse(inverse_x)
                return(inverse_x)
        }
}
