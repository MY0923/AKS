Pod 起動

```
kubectl run --image=centos:centos7 --restart=Never --rm  -it test -- bash
```

ノード確認

```
kubectl get nodes -o wide
```

Pod の確認

```
kubectl get pod -o wide
```
