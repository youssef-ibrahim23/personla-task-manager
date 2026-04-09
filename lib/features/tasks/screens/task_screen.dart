import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/shared/button/button.dart';
import 'package:personal_task/core/shared/text-field/text_field.dart';
import 'package:personal_task/core/utils/DB/models/attachment.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/features/tasks/services/tasks_services.dart';
import 'package:personal_task/features/tasks/view-models/add_task_view_model.dart';
import 'package:personal_task/features/tasks/views/widgets/add_photo_button.dart';
import 'package:personal_task/features/tasks/views/widgets/attachments_grid.dart';
import 'package:personal_task/features/tasks/views/widgets/cutom_drop_down_button.dart';
import 'package:personal_task/features/tasks/views/widgets/date_time_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/DB/models/task.dart';

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

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.08,
        title: Text(
          widget.isUpdate
              ? AppLocalizations.of(context)!.task_details
              : AppLocalizations.of(context)!.add_task,
          style: const TextStyle(color: AppColors.light, fontSize: 35),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),
            CustomTextField(
              hintText: AppLocalizations.of(context)!.enter_task_title,
              controller: controllers['title']!,
            ),
            SizedBox(height: screenHeight * 0.03),
            CustomTextField(
              hintText: AppLocalizations.of(context)!.enter_task_description,
              controller: controllers['description']!,
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomDropDownButton(
                  hintText: AppLocalizations.of(context)!.select_task_category,
                  options: TasksServices.getCategoryOptions(context),
                  selectedValue: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
                CustomDropDownButton(
                  hintText: AppLocalizations.of(context)!.select_task_priority,
                  options: TasksServices.getPriorityOptions(context),
                  selectedValue: selectedPriority,
                  onChanged: (value) {
                    setState(() {
                      selectedPriority = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            DateTimePicker(
              selectedDate: selectedStartDate,
              onChanged: (date) {
                setState(() {
                  selectedStartDate = date;
                });
              },
              hintText: AppLocalizations.of(context)!.select_start_date_time,
            ),
            SizedBox(height: screenHeight * 0.03),
            DateTimePicker(
              selectedDate: selectedEndDate,
              onChanged: (date) {
                setState(() {
                  selectedEndDate = date;
                  selectedReminderDate = TasksServices.calculateReminderDate(
                    context,
                    reminderOption: selectedReminderOption,
                    endDate: date,
                  );
                });
              },
              hintText: AppLocalizations.of(context)!.select_end_date_time,
            ),
            SizedBox(height: screenHeight * 0.03),
            CustomDropDownButton(
              hintText: AppLocalizations.of(context)!.add_reminder,
              options: TasksServices.getReminderOptions(context),
              selectedValue: selectedReminderOption,
              width: MediaQuery.of(context).size.width * 0.9,
              onChanged: (value) {
                setState(() {
                  selectedReminderOption = value;
                  selectedReminderDate = TasksServices.calculateReminderDate(
                    context,
                    reminderOption: value,
                    endDate: selectedEndDate,
                  );
                });
              },
            ),
            SizedBox(height: screenHeight * 0.02),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.public_task,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppStrings.primaryFont,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  Switch(
                    value: isPublic,
                    onChanged: (bool value) {
                      setState(() {
                        isPublic = value;
                      });
                    },
                    activeThumbColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.attachments,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                const Spacer(),
                Text(
                  AppLocalizations.of(context)!.images(attachments.length),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),

            AddPhotoButton(
              selectedImages: attachments,
              onImageSelected: (attachment) {
                setState(() {
                  attachments.add(attachment);
                });
              },
            ),

            SizedBox(height: screenHeight * 0.03),
            AttachmentsGrid(
              attachments: attachments,
              isUpdate: widget.isUpdate,
              onAttachmentDeleted: (attachmentId) {
                setState(() {});
              },
            ),
            SizedBox(height: screenHeight * 0.04),
            Button(
              text: AppLocalizations.of(context)!.save_task,
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
                          .updateTask(widget.task! , context , ref);
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
                          .addTask(task , context , ref);
                    },
              state: ref.watch(taskViewModelProvider).isLoading,
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
