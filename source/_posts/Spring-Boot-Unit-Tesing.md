---
title: Spring Boot Unit Tesing
date: 2017-09-14 13:42:45
tags: Spring Boot
---



## Testing

Spring Boot provides a number of utilities and annotations to help when testing your application. Test support is provided by two modules; `spring-boot-test`contains core items, and `spring-boot-test-autoconfigure` supports auto-configuration for tests.

Most developers will just use the `spring-boot-starter-test` ‘Starter’ which imports both Spring Boot test modules as well has JUnit, AssertJ, Hamcrest and a number of other useful libraries.



## Test scope dependencies

If you use the `spring-boot-starter-test` ‘Starter’ (in the `test` `scope`), you will find the following provided libraries:

- [JUnit](http://junit.org/) — The de-facto standard for unit testing Java applications.
- [Spring Test](https://docs.spring.io/spring/docs/4.3.11.RELEASE/spring-framework-reference/htmlsingle/#integration-testing) & Spring Boot Test — Utilities and integration test support for Spring Boot applications.
- [AssertJ](https://joel-costigliola.github.io/assertj/) — A fluent assertion library.
- [Hamcrest](http://hamcrest.org/JavaHamcrest/) — A library of matcher objects (also known as constraints or predicates).
- [Mockito](http://mockito.org/) — A Java mocking framework.
- [JSONassert](https://github.com/skyscreamer/JSONassert) — An assertion library for JSON.
- [JsonPath](https://github.com/jayway/JsonPath) — XPath for JSON.


These are common libraries that we generally find useful when writing tests. You are free to add additional test dependencies of your own if these don’t suit your needs.



## Unit Testing with @WebMvcTest

Our *Controller* depends on the *Service* layer; let’s only include a single method for simplicity:

```java
@RestController
@RequestMapping("/api")
public class EmployeeRestController {
 
    @Autowired
    private EmployeeService employeeService;
 
    @GetMapping("/employees")
    public List<Employee> getAllEmployees() {
        return employeeService.getAllEmployees();
    }
}
```

Since we are only focused on the *Controller* code, it is natural to mock the *Service* layer code for our unit tests:

```java
@RunWith(SpringRunner.class)
@WebMvcTest(EmployeeRestController.class)
public class EmployeeRestControllerTest {
 
    @Autowired
    private MockMvc mvc;
 
    @MockBean
    private EmployeeService service;
 
    // write test cases here
}
```

To test the *Controllers*, we can use *@WebMvcTest*. It will auto-configure the Spring MVC infrastructure for our unit tests.

In most of the cases, @*WebMvcTest* will be limited to bootstrap a single controller. It is used along with *@MockBean* to provide mock implementations for required dependencies.

*@WebMvcTest* also auto-configures *MockMvc* which offers a powerful way of easy testing MVC controllers without starting a full HTTP server.

Having said that, let’s write our test case:

```java
@Test
public void givenEmployees_whenGetEmployees_thenReturnJsonArray()
  throws Exception {
     
    Employee alex = new Employee("alex");
 
    List<Employee> allEmployees = Arrays.asList(alex);
 
    given(service.getAllEmployees()).willReturn(allEmployees);
 
    mvc.perform(get("/api/employees")
      .contentType(MediaType.APPLICATION_JSON))
      .andExpect(status().isOk())
      .andExpect(jsonPath("$", hasSize(1)))
      .andExpect(jsonPath("$[0].name", is(alex.getName())));
}
```

The *get(…)* method call can be replaced by other methods corresponding to HTTP verbs like *put()*, *post()*, etc. Please note that we are also setting the content type in the request.

*MockMvc* is flexible, and we can create any request using it.