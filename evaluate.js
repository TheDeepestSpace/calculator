// Evaluates an expression of + - * / (no parentheses) with standard precedence.
// Returns a number, or null if the expression is incomplete/invalid.
// Kept separate from the UI so the verilog backend can replace it later.
function evaluate(expr) {
  const tokens = expr.match(/\d+\.?\d*|\.\d+|[+\-*/]/g);
  if (!tokens || tokens.join("") !== expr.replace(/\s/g, "")) return null;
  let i = 0;
  const num = () => {
    let sign = 1;
    while (tokens[i] === "-" || tokens[i] === "+") {
      if (tokens[i++] === "-") sign = -sign;
    }
    const t = tokens[i++];
    return t === undefined || /[*/]/.test(t) ? NaN : sign * parseFloat(t);
  };
  const term = () => {
    let v = num();
    while (tokens[i] === "*" || tokens[i] === "/") {
      const op = tokens[i++];
      const r = num();
      v = op === "*" ? v * r : v / r;
    }
    return v;
  };
  let v = term();
  while (tokens[i] === "+" || tokens[i] === "-") {
    const op = tokens[i++];
    const r = term();
    v = op === "+" ? v + r : v - r;
  }
  return i === tokens.length && Number.isFinite(v) ? v : null;
}
if (typeof module !== "undefined") module.exports = { evaluate };
