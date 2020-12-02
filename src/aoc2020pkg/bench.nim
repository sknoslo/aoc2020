import
  times

template benchmark*(code: untyped) =
  block:
    let start = getTime()
    code
    let elapsed = getTime() - start
    echo "\ncompleted in: " & $elapsed
