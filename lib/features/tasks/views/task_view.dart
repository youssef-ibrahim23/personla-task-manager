import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/shared/button/button.dart';
import 'package:personal_task/core/shared/text-field/text_field.dart';
import 'package:personal_task/core/utils/DB/models/attachment.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/features/tasks/services/tasks_services.dart';
import 'package:personal_task/features/tasks/view-models/add_task_view_model.dart';
import 'package:personal_task/features/tasks/views/widgets/add_photo_button.dart';
import 'package:personal_task/features/tasks/views/widgets/add_plan_button.dart';
import 'package:personal_task/features/tasks/views/widgets/attachments_grid.dart';
import 'package:personal_task/features/tasks/views/widgets/cutom_drop_down_button.dart';
import 'package:personal_task/features/tasks/views/widgets/date_time_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/DB/models/task.dart';
import '../../../core/utils/localization/locale_provider.dart';

DateTime? selectedReminderDate;

class TaskView extends ConsumerStatefulWidget {
  final bool isUpdate;
  final Task? task;

  const TaskView({super.key, this.isUpdate = false, this.task});

  @override
  ConsumerState<TaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends ConsumerState<TaskView> {
  Map<String, TextEditingController> controllers = {
    'title': TextEditingController(),
    'description': TextEditingController(),
  };
  String uid = '-1';

  String? selectedCategory;
  String? selectedPriority;
  DateTime? selectedEndDate;
  DateTime? selectedStartDate;
  String? selectedReminderOption;
  bool isPublic = false;
  List<Attachment> attachments = [];

  @override
  void initState() {
    super.initState();
    _loadUid();
    if (widget.isUpdate && widget.task != null) {
      controllers['title']!.text = widget.task!.title;
      controllers['description']!.text = widget.task!.description;
      selectedCategory = widget.task!.category;
      selectedPriority = widget.task!.priority;
      selectedStartDate = widget.task!.startDate;
      selectedEndDate = widget.task!.endDate;
      selectedReminderDate = widget.task!.reminder;
      isPublic = widget.task?.isShared ?? false;
      if (widget.task!.attachments != null &&
          widget.task!.attachments!.isNotEmpty) {
        attachments = widget.task!.attachments!;
      }
      // Calculate reminder option and convert category/priority to localized after the widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.mounted) {
          setState(() {
            selectedCategory = TasksServices.dbToLocalizedCategory(
              widget.task!.category.trim(),
              context,
            );
            selectedPriority = TasksServices.dbToLocalizedPriority(
              widget.task!.priority.trim(),
              context,
            );
            selectedReminderOption =
                TasksServices.calculateReminderOptionFromDate(
                  context,
                  reminderDate: selectedReminderDate,
                  endDate: selectedEndDate,
                );
          });
        }
      });
    }
  }

  Future<void> _loadUid() async {
    final loadedUid = await Helpers.getUID();
    if (!mounted) return;

    setState(() {
      uid = loadedUid!;
    });
  }

  @override
  Widget build(BuildContext context) {

    final bool canEdit =
        !widget.isUpdate || (widget.task?.ownerId == uid);

    ref.listen(taskViewModelProvider, (prev, next) {
      next.when(
        data: (date) {},
        error: (e, s) {
          Helpers.displayDialog(
            context: context,
            title: AppLocalizations.of(context)!.save_task_failed,
            message: e.toString(),
            dialogType: DialogType.error,
            openMailOption: false,
          );
        },
        loading: () {},
      );
    });
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final locale = ref.watch(localeProvider);
    final isArabic = locale.languageCode == 'ar';
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.08,
        elevation: 0,
        backgroundColor: theme.primaryColor,
        title: Text(
          widget.isUpdate ? localizations.task_details : localizations.add_task,
          style: const TextStyle(
            color: AppColors.light,
            fontSize: 35,
            fontWeight: FontWeight.w700,
            fontFamily: 'Rakkas-Regular',
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            // Basic Information Section
            _buildSectionCard(
              context,
              theme,
              screenWidth,
              icon: Icons.edit_note_rounded,
              title: localizations.basic_information,
              children: [
                SizedBox(height: screenHeight * 0.015),
                CustomTextField(
                  hintText: localizations.enter_task_title,
                  controller: controllers['title']!,
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomTextField(
                  hintText: localizations.enter_task_description,
                  controller: controllers['description']!,
                ),
                SizedBox(height: screenHeight * 0.015),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            // Category & Priority Section
            _buildSectionCard(
              context,
              theme,
              screenWidth,
              icon: Icons.category_rounded,
              title: localizations.category_priority,
              children: [
                SizedBox(height: screenHeight * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomDropDownButton(
                        hintText: localizations.select_task_category,
                        options: TasksServices.getCategoryOptions(context),
                        selectedValue: selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: CustomDropDownButton(
                        hintText: localizations.select_task_priority,
                        options: TasksServices.getPriorityOptions(context),
                        selectedValue: selectedPriority,
                        onChanged: (value) {
                          setState(() {
                            selectedPriority = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.015),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            // Date & Time Section
            _buildSectionCard(
              context,
              theme,
              screenWidth,
              icon: Icons.calendar_today_rounded,
              title: localizations.date_time,
              children: [
                SizedBox(height: screenHeight * 0.015),
                DateTimePicker(
                  selectedDate: selectedStartDate,
                  onChanged: (date) {
                    setState(() {
                      selectedStartDate = date;
                    });
                  },
                  hintText: localizations.select_start_date_time,
                ),
                SizedBox(height: screenHeight * 0.02),
                DateTimePicker(
                  selectedDate: selectedEndDate,
                  onChanged: (date) {
                    setState(() {
                      selectedEndDate = date;
                      selectedReminderDate =
                          TasksServices.calculateReminderDate(
                            context,
                            reminderOption: selectedReminderOption,
                            endDate: date,
                          );
                    });
                  },
                  hintText: localizations.select_end_date_time,
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomDropDownButton(
                  hintText: localizations.add_reminder,
                  options: TasksServices.getReminderOptions(context),
                  selectedValue: selectedReminderOption,
                  width: screenWidth * 0.9,
                  onChanged: (value) {
                    setState(() {
                      selectedReminderOption = value;
                      selectedReminderDate =
                          TasksServices.calculateReminderDate(
                            context,
                            reminderOption: value,
                            endDate: selectedEndDate,
                          );
                    });
                  },
                ),
                SizedBox(height: screenHeight * 0.015),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            // Settings Section
            _buildSectionCard(
              context,
              theme,
              screenWidth,
              icon: Icons.settings_rounded,
              title: localizations.settings,
              children: [
                SizedBox(height: screenHeight * 0.015),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.public_rounded,
                            color: theme.colorScheme.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            localizations.public_task,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppStrings.primaryFont,
                              color: theme.colorScheme.surface,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: isPublic,
                        onChanged: (bool value) {
                          setState(() {
                            isPublic = value;
                          });
                        },
                        activeColor: theme.primaryColor,
                        activeTrackColor: theme.primaryColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            // Attachments Section
            _buildSectionCard(
              context,
              theme,
              screenWidth,
              icon: Icons.attach_file_rounded,
              title: localizations.attachments,
              children: [
                SizedBox(height: screenHeight * 0.015),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        localizations.attachments,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.surface,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        localizations.images(attachments.length),
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                AddPhotoButton(
                  selectedImages: attachments,
                  onImageSelected: (attachment) {
                    setState(() {
                      attachments.add(attachment);
                    });
                  },
                ),
                const SizedBox(height: 12),

                AddPlanButton(
                  onPlanAdded: (attachment) {
                    setState(() {
                      attachments.add(attachment);
                    });
                  },
                ),
                if (attachments.isNotEmpty) ...[
                  SizedBox(height: screenHeight * 0.02),
                  AttachmentsGrid(
                    attachments: attachments,
                    isUpdate: widget.isUpdate,
                    onAttachmentDeleted: (attachmentId) {
                      setState(() {});
                    },
                  ),
                ],
                SizedBox(height: screenHeight * 0.015),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            // Save Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: canEdit ? Button(
                text: localizations.save_task,
                onPressed: widget.isUpdate
                    ? () async {
                        widget.task!.title = controllers['title']!.text;
                        widget.task!.description =
                            controllers['description']!.text;
                        widget.task!.category =
                            TasksServices.localizedToDbCategory(
                              selectedCategory!,
                              context,
                            );
                        widget.task!.priority =
                            TasksServices.localizedToDbPriority(
                              selectedPriority!,
                              context,
                            );
                        widget.task!.startDate = selectedStartDate!;
                        widget.task!.endDate = selectedEndDate!;
                        widget.task!.attachments = attachments;
                        widget.task!.isShared = isPublic;
                        await ref
                            .read(taskViewModelProvider.notifier)
                            .updateTask(widget.task!, context , ref);
                        Navigator.pop(context, true);
                      }
                    : () async {
                        Task task = Task(
                          title: controllers['title']!.text,
                          description: controllers['description']!.text,
                          category: selectedCategory != null
                              ? TasksServices.localizedToDbCategory(
                                  selectedCategory!,
                                  context,
                                )
                              : 'Personal',
                          priority: selectedPriority != null
                              ? TasksServices.localizedToDbPriority(
                                  selectedPriority!,
                                  context,
                                )
                              : 'Medium',
                          startDate: selectedStartDate ?? DateTime.now(),
                          endDate: selectedEndDate ?? DateTime.now(),
                          reminder: selectedReminderDate,
                          isShared: isPublic,
                          attachments: attachments,
                        );
                        await ref
                            .read(taskViewModelProvider.notifier)
                            .addTask(task, context , ref);
                      },
                state: ref.watch(taskViewModelProvider).isLoading,
              ) : Button(text: AppLocalizations.of(context)!.you_can_not_edit_on_task, onPressed: (){}, state: false , isGray: true,),
            ),
            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
    ).animate().moveX(
      begin: isArabic ? -50 : 50,
      end: 0,
      duration: 400.ms,
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    ThemeData theme,
    double screenWidth, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      alignment: Alignment.center,
      width: screenWidth * 0.95,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withOpacity(0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Section Header
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: theme.colorScheme.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                      fontFamily: 'Rakkas-Regular',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Section Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
