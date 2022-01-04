function [M] = quatETc(q, qd, w, K)

% Quaternion Error
qConj = [
    q(1);
    -q(2);
    -q(3);
    -q(4);
];
qErr = qp(qd, qConj);

% Moment
M = -K(1)*qErr(2:4) -K(2)*w;

end