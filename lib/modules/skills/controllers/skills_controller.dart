import 'package:flutter/material.dart';

import '../../../app/controllers/remote_module_controller.dart';
import '../../../app/data/module_row_mapper.dart';
import '../../../app/data/services/salesman_hr_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/localization/t.dart';

/// Skills and certifications HR has recorded for the salesman. Read-only —
/// entered by HR after an assessment or a training program, never by the
/// salesman.
class SkillsController extends RemoteModuleController {
  SkillsController(this._api)
    : super(
        title: t('skills.skill_records'),
        subtitle: t('skills.skills_and_certifications_hr_has_recorded'),
      );

  final SalesmanHrService _api;

  @override
  Future<ModuleData> fetch() async {
    final skills = ModuleRowMapper.listFrom(await _api.skills(), 'skills');

    final certified = skills.where((s) => s['certified_on'] != null).length;

    return (
      rows: skills.map((skill) {
        final level = skill['level']?.toString() ?? '';

        return ModuleRowMapper.row(
          title: skill['skill']?.toString() ?? '',
          subtitle: [
            level.isEmpty ? '' : level[0].toUpperCase() + level.substring(1),
            if (skill['certified_on'] != null)
              t('skills.certified_on', {'date': ModuleRowMapper.date(skill['certified_on'])}),
            if ((skill['remarks']?.toString() ?? '').isNotEmpty)
              skill['remarks'].toString(),
          ].where((part) => part.isNotEmpty).join(' • '),
          trailing: '',
          icon: Icons.workspace_premium_outlined,
          status: level.isNotEmpty ? level : null,
        );
      }).toList(),
      stats: [
        ModuleRowMapper.stat(
          title: t('common.records'),
          value: skills.length.toString(),
          icon: Icons.workspace_premium,
          color: AppColors.primary,
          subtitle: t('skills.skill_records'),
        ),
        ModuleRowMapper.stat(
          title: t('common.certified'),
          value: certified.toString(),
          icon: Icons.verified_outlined,
          color: AppColors.success,
          subtitle: t('common.verified'),
        ),
      ],
    );
  }
}
