## Смотрим, как работают зависимости между ресурсами модулей
_P.S. чтобы запусить модули нужно сначала сделать `terraform get`_

### Случай 1: ресурсы модулей независимы

Картинка **graph(independency).png**

В главном конфигурационном файте `main.tf` конфигурация модуля inst1, должна выглядеть следующим образом:
```
module "inst1" {
  source = "./inst1"
  /*name = "${module.inst2.depend_name}"*/
  name = "nondepend-inst"
}
```
После чего выполняем
```
terrafrom apply
```
Должны увидеть, что подули запускаются параллельно, т.к. ресурсы модулей не зависят друг от друга.


При удалении:

```
terraform destroy
```
Ресурсы будут удаляться тоже одновременно.

### Случай 2: ресурсы модулей зависимы

Картинка **graph(dependency).png**

В главном конфигурационном файте `main.tf` конфигурация модуля inst1, должна выглядеть следующим образом:
```
module "inst1" {
  source = "./inst1"
  name = "${module.inst2.depend_name}"
  /*name = "nondepend-inst"*/
}
```
Видим, что в качестве переменной имени мы передаем выходную переменную из другого модуля (если заглянуть в модуль, то она возвращает instance ID).

Тераформ видит, что ресурсы одного модуля ссылаются на ресурсы другого, и понимает эту зависимость.

Поэтому, если мы запусим:
```
terrafrom apply
```
то увидим, что сначала начнет создаваться только один ресурс, который определен в модуле inst2. Только после того, как этот модуль закончил свою работу и ресурсы, определенные внутри этого модуля, были созданы, начнет свою работу модуль inst1, который так же создаст один инстанс.

При удалении:

```
terraform destroy
```
Ресурсы будут удаляться с учетом зависимостей. Т.е. сначала будет удален инстанс из модуля inst1, имеющий зависимость от инстанса в модуле inst2, а потом будет удален инстанс из модуля inst2.
