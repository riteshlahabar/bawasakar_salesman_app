import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/date_filter_mixin.dart';
import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_order_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// Dispatches heading to the salesman's dealers.
///
/// Progress is read from the dispatch's **`status`**, never from its own
/// `dispatched_at` / `delivered_at` columns: those are not filled by every
/// admin action and are null on live even for a delivered dispatch, which is
/// the same trap that broke order tracking in the dealer app once already.
class DeliveryController extends RemoteModuleController with DateFilterMixin {
  DeliveryController(this._api)
    : super(
        title: t('delivery.delivery'),
        subtitle: t('delivery.dispatches_for_your_dealers_with_courier'),
      );

  final SalesmanOrderService _api;

  /// Statuses that mean the goods have left but have not arrived.
  static const _onTheWay = {'dispatched', 'out_for_delivery'};

  /// Every dispatch, kept so changing the window re-maps what is already here
  /// instead of going back to the network.
  List<Map<String, dynamic>>? _cache;

  /// Dispatches are sparse, so a one-day window would usually read empty.
  @override
  DateFilterMode get initialFilterMode => DateFilterMode.month;

  /// Every page, not just the first — the endpoint paginates 20 at a time.
  /// Pages are capped so a bad `last_page` can never loop forever.
  Future<List<Map<String, dynamic>>> _allDispatches() async {
    final all = <Map<String, dynamic>>[];

    for (var page = 1; page <= 50; page++) {
      final response = await _api.deliveries(page: page);
      // The API sends `data.dispatches`; this read `deliveries` until
      // 2026-09-24, so the screen was always empty.
      final rows = ModuleRowMapper.listFrom(response, 'dispatches');

      all.addAll(rows);

      final paginator = ModuleRowMapper.mapFrom(response, 'dispatches');
      final lastPage = ModuleRowMapper.toInt(paginator['last_page']);

      if (rows.isEmpty || page >= (lastPage == 0 ? 1 : lastPage)) break;
    }

    return all;
  }

  @override
  Future<ModuleData> fetch() async {
    final all = _cache ??= await _allDispatches();

    final dispatches = all
        .where((d) => isInWindow(DateTime.tryParse(_dateOf(d))?.toLocal()))
        .toList();

    final delivered = dispatches.where((d) => _status(d) == 'delivered').length;
    final inTransit = dispatches
        .where((d) => _onTheWay.contains(_status(d)))
        .length;

    return (
      rows: dispatches.map((dispatch) {
        final order = dispatch['order'];
        final dealer = order is Map ? order['dealer'] : null;
        final profile = dealer is Map ? dealer['dealer_profile'] : null;

        return ModuleRowMapper.row(
          title: dispatch['dispatch_no']?.toString() ?? t('common.dispatch'),
          titleTrailing: ModuleRowMapper.date(_dateOf(dispatch)),
          subtitle: _detailLine(dispatch, order, dealer, profile),
          // Empty, so the status badge moves up beside the dispatch number.
          trailing: '',
          icon: Icons.local_shipping,
          status: _status(dispatch),
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('delivery.in_transit'),
          value: inTransit.toString(),
          icon: Icons.local_shipping,
          color: AppColors.orange,
          subtitle: windowLabel,
        ),
        ModuleRowMapper.stat(
          title: t('common.delivered'),
          value: delivered.toString(),
          icon: Icons.task_alt,
          color: AppColors.success,
          subtitle: windowLabel,
        ),
        ModuleRowMapper.stat(
          title: t('common.total'),
          value: dispatches.length.toString(),
          icon: Icons.inventory,
          color: AppColors.primary,
          subtitle: windowLabel,
        ),
      ],
    );
  }

  /// The window filters on when the dispatch was raised, which is the one
  /// timestamp every row always has.
  String _dateOf(Map<String, dynamic> dispatch) =>
      dispatch['created_at']?.toString() ?? '';

  String? _status(Map<String, dynamic> dispatch) =>
      dispatch['status']?.toString();

  /// Who it is going to and what is in it — all of it already in the payload,
  /// which eager-loads `order.dealer.dealerProfile`, and none of it shown
  /// before.
  String _detailLine(
    Map<String, dynamic> dispatch,
    Object? order,
    Object? dealer,
    Object? profile,
  ) {
    final firm = profile is Map ? profile['firm_name']?.toString() ?? '' : '';
    final name = dealer is Map ? dealer['name']?.toString() ?? '' : '';
    final orderNo = order is Map ? order['order_no']?.toString() ?? '' : '';
    final courier = dispatch['courier_name']?.toString() ?? '';
    final awb = dispatch['tracking_no']?.toString() ?? '';

    return [
      if (firm.isNotEmpty) firm else if (name.isNotEmpty) name,
      if (orderNo.isNotEmpty) orderNo,
      if (courier.isNotEmpty) courier,
      if (awb.isNotEmpty) 'AWB $awb',
    ].join(' • ');
  }

  /// The list is held in memory, so changing the window never hits the API.
  @override
  Future<void> onWindowChanged() async {
    final data = await fetch();

    rows.assignAll(data.rows);
    stats.assignAll(data.stats);
  }

  /// A refresh must really refetch — dispatches are created by an admin, so
  /// this screen has no other way to learn about a new one.
  @override
  Future<void> load() {
    _cache = null;

    return super.load();
  }
}
