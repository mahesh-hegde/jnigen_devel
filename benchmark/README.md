# jnigen benchmarks
Benchmarks jnigen-generated bindings against platform channels.

The UI just compares dart based bindings.

Run integration_test in profile mode using following command:

```sh
flutter drive '--driver=test_driver/benchmark_test_driver.dart' '--target=integration_test/benchmark_test.dart' --profile --no-dds
```

* May need to pass `-d $android_device_id` to disambiguate between devices.

## Adding more benchmark cases

* Add corresponding method channel handler.
* Add functions to `SyncMeasuredFunctions` and `AsyncMeasuredFunctions`
* Add members to MeasurementResult
* Implement functions
* Edit `getBenchmarkNames` and `getBenchmarkResults` in `Benchmarker` class.

