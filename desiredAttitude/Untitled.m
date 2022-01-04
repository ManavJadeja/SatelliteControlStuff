vgtSat = satellite.Vgt;
VectFactory = vgtSat.Vectors.Factory;
AngFactory = vgtSat.Angles.Factory;

earthFixedX = root.CentralBodies.Earth.Vgt.Vectors.Item('Fixed.X');
satSunVector = vgtSat.Vectors.Item('Sun');

betwVect = AngFactory.Create('RotationAngle1', 'Rotation Angle', 'eCrdnAngleTypeBetweenVectors');

betwVect.FromVector.SetVector(earthFixedX);
betwVect.ToVector.SetVector(satSunVector);
rotationAxis = VectFactory.CreateCrossProductVector('RotationAxis1', earthFixedX, satSunVector);

vector = satellite.VO.Vector;

vector2 = vector.RefCrdns.Add('eVectorElem', 'Satellite/SPICESat RotationAxis1');
vector2.Visible = true;
vector2.LabelVisible = true;

angle2 = vector.RefCrdns.Add('eAngleElem', 'Satellite/SPICESat RotationAngle1');
angle2.Visible = true;
angle2.LabelVisible = true;
angle2.AngleValueVisible = true;

