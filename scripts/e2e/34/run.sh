#!/bin/bash

kubectl delete namespace/thirtyfour
kubectl create namespace thirtyfour

## Customer Had issues with 34 ingresses
## https://github.com/Azure/application-gateway-kubernetes-ingress/issues/528

for NUMBER in {0..28}; do

cat <<EOF | KUBECONFIG=$HOME/.kube/config kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: depl-$NUMBER
  namespace: thirtyfour
spec:
  selector:
    matchLabels:
      app: ws-app-$NUMBER
  replicas: 1
  template:
    metadata:
      labels:
        app: ws-app-$NUMBER
    spec:
      containers:
        - name: ctr-$NUMBER
          imagePullPolicy: Always
          image: docker.io/kennethreitz/httpbin
          ports:
            - name: port-$NUMBER
              containerPort: 80
          livenessProbe:
            httpGet:
              path: /status/200
              port: 80
            initialDelaySeconds: 3
            periodSeconds: 3
      imagePullSecrets:
        - name: acr-creds

---

apiVersion: v1
kind: Service
metadata:
  name: svc-$NUMBER
  namespace: thirtyfour
spec:
  selector:
    app: ws-app-$NUMBER
  ports:
  - name: pp-$NUMBER
    protocol: TCP
    port: 80
    targetPort: port-$NUMBER

---

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ing-$NUMBER
  namespace: thirtyfour
  annotations:
    kubernetes.io/ingress.class: azure/application-gateway
    appgw.ingress.kubernetes.io/ssl-redirect-XXX: "true"
spec:
  tls:
   - hosts:
     - ws-$NUMBER.mis.li
     secretName: testsecret-tls
  rules:
    - host: ws-$NUMBER.mis.li
      http:
        paths:
        - path: /igl/oo
          backend:
            serviceName: svc-$NUMBER
            servicePort: pp-$NUMBER

        - path: /igloo
          backend:
            serviceName: svc-$NUMBER
            servicePort: pp-$NUMBER

        - path: /iglxx/
          backend:
            serviceName: svc-$NUMBER
            servicePort: pp-$NUMBER

        - path: /iguana/*
          backend:
            serviceName: svc-$NUMBER
            servicePort: pp-$NUMBER

        - path: /status/*
          backend:
            serviceName: svc-$NUMBER
            servicePort: pp-$NUMBER

---

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    appgw.ingress.kubernetes.io/ssl-redirect: "true"
    kubernetes.io/ingress.class: azure/application-gateway
  name: ing-x-$NUMBER
  namespace: thirtyfour
spec:
  tls:
   - hosts:
     - ws-$NUMBER.mis.li
     - ws-$NUMBER-a.mis.li
     - ws-$NUMBER-b.mis.li
     secretName: testsecret-tls
  rules:
  - host: ws-$NUMBER-a.mis.li
    http:
      paths:
      - backend:
          serviceName: svc-$NUMBER
          servicePort: pp-$NUMBER
        path: /path
      - backend:
            serviceName: svc-$NUMBER
            servicePort: pp-$NUMBER
        path: /path/*
      - backend:
          serviceName: svc-$NUMBER
          servicePort: pp-$NUMBER
        path: /path-$NUMBER
      - backend:
            serviceName: svc-$NUMBER
            servicePort: pp-$NUMBER
        path: /path-$NUMBER/*
  - host: ws-$NUMBER-b.mis.li
    http:
      paths:
      - backend:
            serviceName: svc-$NUMBER
            servicePort: pp-$NUMBER
        path: /path
      - backend:
          serviceName: svc-$NUMBER
          servicePort: pp-$NUMBER
        path: /path/*
      - backend:
          serviceName: svc-$NUMBER
          servicePort: pp-$NUMBER
        path: /path-$NUMBER
      - backend:
          serviceName: svc-$NUMBER
          servicePort: pp-$NUMBER
        path: /path-$NUMBER/*

EOF

done

cat <<EOF | KUBECONFIG=$HOME/.kube/config kubectl apply -f -
apiVersion: v1
data:
  tls.crt: QmFnIEF0dHJpYnV0ZXMKICAgIGxvY2FsS2V5SUQ6IDAxIDAwIDAwIDAwIAogICAgMS4zLjYuMS40LjEuMzExLjE3LjMuNzE6IDREIDAwIDQ5IDAwIDRFIDAwIDQ5IDAwIDRFIDAwIDU0IDAwIDJEIDAwIDQ4IDAwIDU0IDAwIDUyIDAwIDM2IDAwIDU2IDAwIDU0IDAwIDM2IDAwIDJFIDAwIDZFIDAwIDZGIDAwIDcyIDAwIDc0IDAwIDY4IDAwIDYxIDAwIDZEIDAwIDY1IDAwIDcyIDAwIDY5IDAwIDYzIDAwIDYxIDAwIDJFIDAwIDYzIDAwIDZGIDAwIDcyIDAwIDcwIDAwIDJFIDAwIDZEIDAwIDY5IDAwIDYzIDAwIDcyIDAwIDZGIDAwIDczIDAwIDZGIDAwIDY2IDAwIDc0IDAwIDJFIDAwIDYzIDAwIDZGIDAwIDZEIDAwIDAwIDAwIApzdWJqZWN0PS9DTj13cy5taXMubGkKaXNzdWVyPS9DTj13cy5taXMubGkKLS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURHRENDQWdDZ0F3SUJBZ0lRTW5jcWFhK2ovNmREVjl5TFFOWExWVEFOQmdrcWhraUc5dzBCQVFzRkFEQVUKTVJJd0VBWURWUVFEREFsM2N5NXRhWE11Ykdrd0hoY05NVGt3TlRFNE1ETTBOekEyV2hjTk1qQXdOVEU0TURRdwpOekEyV2pBVU1SSXdFQVlEVlFRRERBbDNjeTV0YVhNdWJHa3dnZ0VpTUEwR0NTcUdTSWIzRFFFQkFRVUFBNElCCkR3QXdnZ0VLQW9JQkFRQ2xXVGNIU1gwWkQ3eHBsdFpkNDh4QXJZQ1NkMUZiVjF4L3BNVHJMT2RIQ0NSRnVKRnkKM2xoZVV3OGdXQjRSL3hiUE9IdURkNlUwMzA3UWxqUzdvWnJBOGIzbGhDakgwYnVVY1MwMUZyMmxyaUp2QVA4TQpIQys4SytZODRhZzYwcnNnblNRTVA1ZDBYU1RQWXQ3SHk2eldsUWNNU2U2bFh1aDIwdmUyaWk2RDdaZWhVMkF1CmZtWmJNSWFxeU9LREd5YzBGb25iM1RQNVdXdnJqV1p3aEVUeVVxdFZ4LzZ6QURDemxMc1lDZmZZVE1SL2t6WVAKYldIMDh3WWYwVk5hM1ZrVWpHeW9EbEFzQ1pzMHdwc0E5d3hydE9NTElYNFF0MW1rdFcxTGpzNlhOREcvVTBNOQp2RkZQUUlpY0tWc2tkcTFVd1Z1YW16bXJ0cXh4RlVlR0VWeXhBZ01CQUFHalpqQmtNQTRHQTFVZER3RUIvd1FFCkF3SUZvREFkQmdOVkhTVUVGakFVQmdnckJnRUZCUWNEQWdZSUt3WUJCUVVIQXdFd0ZBWURWUjBSQkEwd0M0SUoKZDNNdWJXbHpMbXhwTUIwR0ExVWREZ1FXQkJRTERrWXQ2SEJlYjVIczhwL0ZnakpScDliR3FEQU5CZ2txaGtpRwo5dzBCQVFzRkFBT0NBUUVBbGYyVjJPZWZCMTZwR1lEMFR6RTNzZG8yV1UwWE03cncrRGp5aE94NTM4NGdIVGU0CjliMThkaTM2eFFsMkJZdTdZQlFoK3pmU05DbUFJbkhZc3dOUDF3U1FxV1daT2Q1eS96YVRJZkJ0MTArQkFSUXQKWlN3eDgrN3RnemxLYlp4R3hBRUhtUXN1WUVoaGRVWWtZNlNuc2lMQzU0aUsxR2ZyMFdLZHNtQVRKNkVaVVZXZAoxaHVNWVBnL3g1QmU2dWIyMk9jOFk5WXF2NGIrbGx3OFV3OWYzZWZyRVRsdU4xVGhQMHBvUDFEZ0VKY3pocFpPCkxhZGtSUmxnOWd4NHhEYURVSXdvcEhFZnNOT3ErN2pKWTlWVlhHakpaWVg1SmJBNG1GVkJSUWpXWkRBSTF4dlIKUjJaNExkNWZWOHZScHlsdUQ2U25JcDFxeUNka3ZzanFCdEJ5OVE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
  tls.key: QmFnIEF0dHJpYnV0ZXMKICAgIE1pY3Jvc29mdCBMb2NhbCBLZXkgc2V0OiA8Tm8gVmFsdWVzPgogICAgbG9jYWxLZXlJRDogMDEgMDAgMDAgMDAgCiAgICBmcmllbmRseU5hbWU6IHRlLTgzMDkwZjk3LWIzOWItNDFmMC05YmYyLTkzNTM0MjhlODdlYQogICAgTWljcm9zb2Z0IENTUCBOYW1lOiBNaWNyb3NvZnQgU29mdHdhcmUgS2V5IFN0b3JhZ2UgUHJvdmlkZXIKS2V5IEF0dHJpYnV0ZXMKICAgIFg1MDl2MyBLZXkgVXNhZ2U6IDkwIAotLS0tLUJFR0lOIFBSSVZBVEUgS0VZLS0tLS0KTUlJRXZRSUJBREFOQmdrcWhraUc5dzBCQVFFRkFBU0NCS2N3Z2dTakFnRUFBb0lCQVFDbFdUY0hTWDBaRDd4cApsdFpkNDh4QXJZQ1NkMUZiVjF4L3BNVHJMT2RIQ0NSRnVKRnkzbGhlVXc4Z1dCNFIveGJQT0h1RGQ2VTAzMDdRCmxqUzdvWnJBOGIzbGhDakgwYnVVY1MwMUZyMmxyaUp2QVA4TUhDKzhLK1k4NGFnNjByc2duU1FNUDVkMFhTVFAKWXQ3SHk2eldsUWNNU2U2bFh1aDIwdmUyaWk2RDdaZWhVMkF1Zm1aYk1JYXF5T0tER3ljMEZvbmIzVFA1V1d2cgpqV1p3aEVUeVVxdFZ4LzZ6QURDemxMc1lDZmZZVE1SL2t6WVBiV0gwOHdZZjBWTmEzVmtVakd5b0RsQXNDWnMwCndwc0E5d3hydE9NTElYNFF0MW1rdFcxTGpzNlhOREcvVTBNOXZGRlBRSWljS1Zza2RxMVV3VnVhbXptcnRxeHgKRlVlR0VWeXhBZ01CQUFFQ2dnRUJBSmxFdW9LUnQxa2N3Z3lxV2lrTCtKQlhnOS9BcEhSajVZVVlhY1NKaWhUSQowajZpbUloKzNERUxFdkZyWE94WHBZQU9Ia2UrQnpDY2NvVmRScUpLYVpYQ1A4RlpvU2VnSFIyN1R5bHYyL21SCkViQU5uMTFOWDE0dzN5bStEdC8vNkorUnFoR0VmTkxMYUV5b25GTmRVK2hRbWdqbEcwYkZVL3laRUM5dnBUQjUKOWU5WFl2elBHZDdLQjByK0dMWC9FalpUSURJZDB3SlJrZTB3UURqK284V3NMZTR1cTRKdkU5UWVmNEswVnEyNQpCSjFtKzcrWWxqTGlHaUNuRERMc2pRNGl6K2Q2c2xGc3p0eEc0SDVQbHhjcFFYTlRncVUyd1ZrYjNoNnpsUHN4CkthRE9Odms4NU5kdlU2QlJiaGJjTVI4cHhtUXM5K1BTU05NWHlLMWRXOVVDZ1lFQXpwWnI0UzAyUEpiSVpBcmkKU1F2Zm9pUU5KN1QycjlNNzNFc0FsM0t0a0laTHZFYTRvZjZJNXVYZGVOUmtGMkMvSk5kcCtsUEZpbDAwdk5TbQoyWHlUTFVERXdUL1k0WEJ1L2U2ZUVjVFYzUXFsS1FvRHMxQXgrOFdkQ2llMWd2WHR4dVVtRmVxcUwvWi9PM1dPCis0cHZ1eHpDT0hyd3I4MEpBSHRjUGtkY2xpY0NnWUVBek9XdUhLS21pdWtEeHV3ZWJia3hJSVNIV3pvcjJHemcKSTl1V21hMnQ3U0VZMlhibWZ0YWhrQW5iaVBpYjJxc1BDazhNU2wvYi9PR0kwbzBEbkVKbmUvcmpFc3crYU10eApyNm51eTR6L1FwdmtlWitxbDZMNmpJYWgvZ1JidjB0Vk9ONlJkSzNscEYrRWwrV24yajRGTmNYWnpYQjhjdmVoCkRtcGtCdDRhVldjQ2dZQTVEaW8xUW50Y09IaVh5TG0rV3Qwa3RyZzdZeXRPWEJTSVB0Nm05VEVpWFRURmh2S3YKS3RFOGsvZWF5MjNwVnZyemZkcnpHL2ZPd3ZjeHY3bGxENWJHUk1FU2JrUEQzMzJIL0VNRHZVMGpnekVpS0hYbApMQnpoNEM0REEveUpjc3A4eUFUQXdOTEg5RmduWDh4aGhGWmZZdzN3ODJOTjZsNjJGMXZlaDI3MnVRS0JnRXkxCkE4eldtNURQa1Vsc1ppdmZzK09mbWVqdVN6SFgrTVdUMUxxdHlicEh0THpkQlllZ3BKVi9DMEFwQ25mL3FEN00KdnlZczR2ZTJHM252cnRWV0N0WGdaQmhLZkdiUkd6dVBXOFc2Z0dtWVlSMmpSOE5ERVplQVk2N3NSTWpGMUI3WgpQQTA1ZVFwamRBbEZ3ZVF6YWRIcXd4SmxOVUg1TU1OcjB3eTdJNUtyQW9HQVZVVDFmSVA5SWs5NGp6YkU5bU96CkRaRWRqTFVReHUxZ3A4ZTExOVdtWVZ6SkRpaVN3dXdvY3ViUEVFaE1YOFJSN1dHRkhXUzdEVUx3RlU5TWQxL08KQ1dkTmZiNjJpZ2FiOGh1NUtOb1BhVWVUMVIrWnQ4azdDbGpDRUR3bnNKbzROT05JMHBIU1RFRVVPSUREZ1JhMApjam9OUUlDUXI5NlZ3V29PVFJjbTRRND0KLS0tLS1FTkQgUFJJVkFURSBLRVktLS0tLQo=
kind: Secret
metadata:
  creationTimestamp: "2019-05-20T22:54:33Z"
  name: thirtyfour
  namespace: thirtyfour
type: kubernetes.io/tls
EOF



# kubectl delete namespace/thirtyfour