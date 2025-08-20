import moment from 'moment-timezone';

export const mergeDateAndTime = (dateStr, timeStr) => {
  const datePart = moment(dateStr).utc();
  const timePart = moment(timeStr).utc();

  return datePart
    .hour(timePart.hour())
    .minute(timePart.minute())
    .second(timePart.second())
    .millisecond(timePart.millisecond())
    .utc()
    .toISOString();
};

export function getRatesForTimeOnDate(
  data,
  filterDate,
  filterStartTime,
  filterEndTime
) {
  const results = [];
  data?.Scheduler?.SchedulerDate?.forEach((scheduleDate) => {
    scheduleDate.Time.forEach((timeSlot) => {
      if (
        moment(filterStartTime).isSameOrAfter(timeSlot.startTime, 'minute') &&
        moment(filterEndTime).isSameOrBefore(timeSlot.endTime, 'minute') &&
        moment(scheduleDate.date).format('ddd') ===
          moment(filterDate).format('ddd')
      ) {
        results.push({
          ...timeSlot,
          date: scheduleDate.date,
          startTime: timeSlot.startTime,
          endTime: timeSlot.endTime,
          rate: timeSlot.rate || 0, // Ensure rate is defined
        });
      }
    });
  });
  return results.length > 0 ? results[0]?.rate : null;
}
