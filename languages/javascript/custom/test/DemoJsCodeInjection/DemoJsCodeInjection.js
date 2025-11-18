// Test cases for code injection vulnerability detection
// Based on juice-shop vulnerability: https://github.com/juice-shop/juice-shop/blob/master/routes/showProductReviews.ts

const express = require('express');
const app = express();

// NON_COMPLIANT: Direct code injection via MongoDB $where clause
app.get('/reviews/:id', (req, res) => {
  const id = req.params.id;
  // Vulnerable: User input concatenated into $where clause
  db.reviewsCollection.find({ $where: 'this.product == ' + id }).then(reviews => {
    res.json(reviews);
  });
});

// NON_COMPLIANT: Code injection via eval
app.get('/calc', (req, res) => {
  const expr = req.query.expression;
  const result = eval(expr); // Direct eval of user input
  res.send(result.toString());
});

// NON_COMPLIANT: Code injection via Function constructor
app.get('/execute', (req, res) => {
  const code = req.body.code;
  const fn = new Function(code); // Function constructor with user input
  fn();
});

// NON_COMPLIANT: Code injection via setTimeout with string
app.get('/delayed', (req, res) => {
  const action = req.query.action;
  setTimeout(action, 1000); // setTimeout with user input string
});

// NON_COMPLIANT: MongoDB $where with direct user input
app.get('/search', (req, res) => {
  db.collection.find({ $where: req.query.filter });
});

// COMPLIANT: Parameterized query (safe)
app.get('/safe-reviews/:id', (req, res) => {
  const id = parseInt(req.params.id, 10);
  db.reviewsCollection.find({ product: id }).then(reviews => {
    res.json(reviews);
  });
});

// COMPLIANT: Safe calculation without eval
app.get('/safe-calc', (req, res) => {
  const a = parseInt(req.query.a, 10);
  const b = parseInt(req.query.b, 10);
  const result = a + b;
  res.send(result.toString());
});