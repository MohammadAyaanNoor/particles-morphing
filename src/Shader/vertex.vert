uniform float uSize;
uniform vec2 uResolution;
uniform float uProgress;
uniform vec3 uColorA;
uniform vec3 uColorB;
uniform float uTime;

attribute vec3 aPositionTarget;
attribute float aSize;

varying vec3 vColor;

#include ./includes/simplexNoise3d.vert

void main(){
    float noiseOrigin = snoise(position * 0.2);
    float noiseTarget = snoise(aPositionTarget * 0.2);
    float noise = mix(noiseOrigin, noiseTarget, uProgress);
    noise = smoothstep(-1.0,1.0,noise);
    float duration = 0.4;
    float delay = (1.0 - duration) * noise;
    float end = duration + delay;
    
    float progress = smoothstep(delay, end, uProgress);
    vec3 mixedPosition = mix(position, aPositionTarget, progress);
    vec4 modelPosition = modelMatrix * vec4(mixedPosition, 1.0);
    modelPosition.x += sin(modelPosition.y * 15.0 + uTime * 2.0) * 0.08;
    modelPosition.y += cos(modelPosition.x * 15.0 + uTime * 2.0) * 0.08;
    modelPosition.z += sin(modelPosition.x * 15.0 + uTime * 2.0) * 0.08;
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;
    gl_Position = projectedPosition;


    gl_PointSize = uSize * uResolution.y * aSize;
    gl_PointSize *= (1.0 / - viewPosition.z);

    // Varyings
    vColor = mix(uColorA,uColorB,noise);

}